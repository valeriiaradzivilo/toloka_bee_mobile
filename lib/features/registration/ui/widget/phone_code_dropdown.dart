import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../common/list_extension.dart';
import '../../../../data/models/country.dart';

class PhoneCodeDropdown extends StatefulWidget {
  const PhoneCodeDropdown({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final void Function(Country) onChanged;
  final String? initialValue;

  @override
  PhoneCodeDropdownState createState() => PhoneCodeDropdownState();
}

class PhoneCodeDropdownState extends State<PhoneCodeDropdown> {
  late Future<List<Country>> _countriesFuture;
  Country? _selected;

  @override
  void initState() {
    super.initState();
    _countriesFuture = fetchCountries().then((final list) {
      if (widget.initialValue != null) {
        final full = widget.initialValue!;
        final matches =
            list.where((final c) => full.startsWith(c.dialCode)).toList()
              ..sort(
                (final a, final b) =>
                    b.dialCode.length.compareTo(a.dialCode.length),
              );
        if (matches.isNotEmpty) {
          _selected = matches.first;
          WidgetsBinding.instance.addPostFrameCallback((final _) {
            widget.onChanged(_selected!);
          });
        }
      }
      return list;
    });
  }

  Future<List<Country>> fetchCountries() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://restcountries.com/v3.1/all');
      final list = (response.data as List?)
          .orEmpty
          .map((final e) => Country.fromJson(e as Map<String, dynamic>))
          .where(
            (final c) => !c.name.toLowerCase().contains('russia'),
          )
          .toList()
        ..sort((final a, final b) => a.name.compareTo(b.name));
      return list;
    } catch (e) {
      debugPrint('Error fetching countries: $e');
      return [];
    }
  }

  String? get remainder {
    final full = widget.initialValue;
    final code = _selected?.dialCode;
    if (full != null && code != null && full.startsWith(code)) {
      return full.substring(code.length);
    }
    return null;
  }

  @override
  Widget build(final BuildContext context) => FutureBuilder<List<Country>>(
        future: _countriesFuture,
        builder: (final ctx, final snap) {
          if (!snap.hasData) return const CircularProgressIndicator();
          final items = snap.data!;
          return SizedBox(
            width: 111,
            child: GestureDetector(
              onTap: () async {
                final selected = await showModalBottomSheet<Country>(
                  context: context,
                  isScrollControlled: true,
                  builder: (final context) {
                    String query = '';
                    List<Country> filtered = items;
                    return StatefulBuilder(
                      builder: (final context, final setModalState) => Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: translate('contacts.phone_search'),
                                  prefixIcon: const Icon(Icons.search),
                                ),
                                onChanged: (final val) {
                                  setModalState(() {
                                    query = val;
                                    filtered = items
                                        .where(
                                          (final c) =>
                                              c.name.toLowerCase().contains(
                                                    query.toLowerCase(),
                                                  ) ||
                                              c.dialCode.contains(query),
                                        )
                                        .toList();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (final context, final index) {
                                  final c = filtered[index];
                                  return ListTile(
                                    leading: Text(c.emojiFlag),
                                    title: Text('${c.name} (${c.dialCode})'),
                                    onTap: () => Navigator.pop(context, c),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (selected != null) {
                  setState(() => _selected = selected);
                  widget.onChanged(selected);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: translate('contacts.phone_code'),
                  border: const OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    if (_selected != null)
                      Text('${_selected!.emojiFlag} ${_selected!.dialCode}')
                    else
                      const Text('+...'),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
