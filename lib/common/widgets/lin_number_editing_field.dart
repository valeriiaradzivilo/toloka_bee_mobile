import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LinNumberEditingField extends StatefulWidget {
  const LinNumberEditingField({
    super.key,
    this.label,
    required this.controller,
    this.isRequired = false,
    this.onChanged,
    this.minValue,
    this.maxValue,
  });
  final String? label;
  final TextEditingController controller;
  final bool isRequired;
  final double? minValue;
  final double? maxValue;
  final Function(String)? onChanged;

  @override
  State<LinNumberEditingField> createState() => _LinNumberEditingFieldState();
}

class _LinNumberEditingFieldState extends State<LinNumberEditingField> {
  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          label: widget.label != null ? Text(widget.label!) : null,
          errorMaxLines: 3,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (final value) {
          if (!widget.isRequired && (value == null || value.isEmpty)) {
            return null;
          }

          if (value == null || (widget.isRequired && value.isEmpty)) {
            return translate('validation.error.field.not.empty');
          }
          final parsed = double.tryParse(value);
          if (parsed == null) {
            return translate('validation.error.field.not.number');
          }
          if (widget.minValue != null && parsed <= widget.minValue!) {
            return translate(
              'validation.error.field.min.value',
              args: {
                'value': widget.minValue.toString(),
              },
            );
          }
          if (widget.maxValue != null && parsed > widget.maxValue!) {
            return translate(
              'validation.error.field.max.value',
              args: {
                'value': widget.maxValue.toString(),
              },
            );
          }
          return null;
        },
        onChanged: (final value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        maxLines: null,
        minLines: 1,
      );
}
