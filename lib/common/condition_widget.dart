import 'package:flutter/material.dart';

class ConditionWidget extends StatelessWidget {
  const ConditionWidget(
      {super.key,
      required this.condition,
      required this.onTrue,
      required this.onFalse});
  final bool condition;
  final Widget onTrue;
  final Widget onFalse;

  @override
  Widget build(BuildContext context) {
    return condition ? onTrue : onFalse;
  }
}
