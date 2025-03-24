import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../constants/padding_constants.dart';
import '../constants/validation_constant.dart';

enum TextFieldOption {
  undefined,
  email,
  password,
  name;

  double? get maxFieldWidth =>
      switch (this) { name => 500, email => 700, password => 700, _ => null };
}

class LinTextField extends StatefulWidget {
  const LinTextField({
    super.key,
    required this.controller,
    this.initialValue,
    this.isRequired = false,
    this.label,
    this.option = TextFieldOption.undefined,
    this.textToMatch,
    this.onChanged,
    this.onValidate,
  });
  final TextEditingController controller;
  final String? initialValue;
  final bool isRequired;
  final String? label;
  final TextFieldOption option;
  final String? textToMatch;
  final Function(String)? onChanged;
  final Function(bool)? onValidate;

  @override
  State<LinTextField> createState() => _LinTextFieldState();
}

class _LinTextFieldState extends State<LinTextField> {
  bool obscureText = true;
  String? errorText;
  String? _validate(final String? value, final BuildContext context) {
    if (widget.textToMatch != null) {
      if (widget.controller.text != widget.textToMatch) {
        return translate('validation.error.password.match');
      }
      return null;
    }
    if (value?.isEmpty ?? widget.isRequired) {
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
              minLines: widget.option == TextFieldOption.password ? null : 1,
              maxLines: widget.option == TextFieldOption.password ? 1 : 100,
              obscureText:
                  widget.option == TextFieldOption.password && obscureText,
              enableSuggestions: widget.option != TextFieldOption.password,
              autocorrect: widget.option != TextFieldOption.password,
              validator: (final value) => _validate(value, context),
              decoration: InputDecoration(
                label: Text(widget.label ?? ''),
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
          if (widget.option == TextFieldOption.password) ...[
            IconButton(
              onPressed: () => setState(() => obscureText = !obscureText),
              icon: Icon(obscureText ? FeatherIcons.eye : FeatherIcons.eyeOff),
            ),
            SizedBox(width: PaddingConstants.medium),
            Tooltip(
              message: translate('password.rules'),
              child: const Icon(Icons.info_outline_rounded),
            ),
          ],
        ],
      ),
    );
}
