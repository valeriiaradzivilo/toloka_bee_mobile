import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
          return DropdownButton<Country>(
            hint: const Text('+...'),
            value: _selected,
            items: items
                .map(
                  (final c) => DropdownMenuItem(
                    value: c,
                    child: Text('${c.emojiFlag} ${c.dialCode}'),
                  ),
                )
                .toList(),
            onChanged: (final c) {
              if (c != null) {
                setState(() => _selected = c);
                widget.onChanged(c);
              }
            },
          );
        },
      );
}
