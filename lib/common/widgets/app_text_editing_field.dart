import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../constants/padding_constants.dart';
import '../constants/validation_constant.dart';
import '../theme/toloka_fonts.dart';

enum TextFieldOption {
  undefined,
  email,
  password,
  name;

  double? get maxFieldWidth =>
      switch (this) { name => 500, email => 700, password => 700, _ => null };
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.initialValue,
    this.isRequired = false,
    this.label,
    this.option = TextFieldOption.undefined,
    this.textToMatch,
    this.onChanged,
    this.onValidate,
    this.maxLines,
    this.maxSymbols,
    this.obscureText = false,
  });
  final TextEditingController controller;
  final String? initialValue;
  final bool isRequired;
  final String? label;
  final TextFieldOption option;
  final String? textToMatch;
  final int? maxLines;
  final Function(String)? onChanged;
  final Function(bool)? onValidate;
  final int? maxSymbols;
  final bool obscureText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool obscureText = true;
  String? errorText;
  String? _validate(final String? value, final BuildContext context) {
    if (widget.textToMatch != null) {
      if (widget.controller.text != widget.textToMatch) {
        return translate('validation.error.password.match');
      }
      return null;
    }
    if ((value?.isEmpty ?? true) && widget.isRequired) {
      return translate('validation.error.field.not.empty');
    } else if (widget.option == TextFieldOption.email) {
      return ValidationConstant.email(value, context);
    } else if (widget.option == TextFieldOption.password) {
      return ValidationConstant.password(value, context);
    } else if (widget.option == TextFieldOption.name) {
      return ValidationConstant.name(value, context);
    }
    return null;
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Container(
        constraints: BoxConstraints(
          maxWidth: widget.option.maxFieldWidth ?? double.infinity,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                minLines: widget.option == TextFieldOption.password ||
                        widget.obscureText
                    ? null
                    : 1,
                maxLines: widget.option == TextFieldOption.password ||
                        widget.obscureText
                    ? 1
                    : (widget.maxLines ?? 10),
                obscureText: (widget.option == TextFieldOption.password ||
                        widget.obscureText) &&
                    obscureText,
                enableSuggestions: widget.option != TextFieldOption.password,
                autocorrect: widget.option != TextFieldOption.password,
                validator: (final value) => _validate(value, context),
                maxLength: widget.maxSymbols,
                decoration: InputDecoration(
                  label: Text(
                    widget.label ?? '',
                    style: TolokaFonts.small.style,
                  ),
                  errorText: errorText,
                  errorMaxLines: 10,
                ),
                onChanged: (final value) {
                  widget.onChanged?.call(value);
                  setState(() => errorText = _validate(value, context));
                  widget.onValidate?.call(errorText == null);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            if (widget.option == TextFieldOption.password ||
                widget.obscureText) ...[
              IconButton(
                onPressed: () => setState(() => obscureText = !obscureText),
                icon:
                    Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              ),
            ],
            if (widget.option == TextFieldOption.password) ...[
              SizedBox(width: PaddingConstants.medium),
              Tooltip(
                message: translate('password.rules'),
                triggerMode: TooltipTriggerMode.tap,
                child: const Icon(Icons.info_outline_rounded),
              ),
            ],
          ],
        ),
      );
}
