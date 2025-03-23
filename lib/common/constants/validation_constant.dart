import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ValidationConstant {
  static String? email(final String? email, final BuildContext context) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (email == null) {
      return translate('validation.error.field.not.empty');
    } else if (!emailRegExp.hasMatch(email)) {
      return translate('validation.error.email.invalid');
    }
    return null;
  }

  static String? password(final String? password, final BuildContext context) {
    final uppercaseRegExp = RegExp('[A-Z]+.+');
    final lowercaseRegExp = RegExp('[a-z]+.+');
    final digitsRegExp = RegExp('\\d+');
    final charactersRegExp = RegExp('[@!]+');
    final forbiddenCharactersRegExp = RegExp('[^!@a-zA-Z\\d]');
    if (password == null) {
      return translate('validation.error.field.not.empty');
    } else if (password.isEmpty || password.length < 8) {
      return translate('validation.error.password.min.length');
    } else if (!lowercaseRegExp.hasMatch(password)) {
      return translate('validation.error.password.rules.lowercase');
    } else if (!uppercaseRegExp.hasMatch(password)) {
      return translate('validation.error.password.rules.uppercase');
    } else if (!digitsRegExp.hasMatch(password)) {
      return translate('validation.error.password.rules.digits');
    } else if (!charactersRegExp.hasMatch(password)) {
      return translate('validation.error.password.rules.other.characters');
    } else if (forbiddenCharactersRegExp.hasMatch(password)) {
      return translate('validation.error.password.rules.forbidden.characters');
    }

    return null;
  }

  static String? name(final String? name, final BuildContext context) {
    if (name == null) {
      return translate('validation.error.field.not.empty');
    } else if (name.isEmpty) {
      return translate('validation.error.field.not.empty');
    } else if (name.contains(' ')) {
      return translate('validation.error.name.no.spaces');
    }

    return null;
  }
}
