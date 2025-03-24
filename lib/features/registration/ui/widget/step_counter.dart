import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class StepCounter extends StatelessWidget {
  const StepCounter({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(final BuildContext context) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (final index) {
            final isActive = index < currentStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 24 : 16,
              decoration: BoxDecoration(
                color: isActive ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          translate(
            translate(
              'step.of',
              args: {
                'current': currentStep,
                'total': totalSteps,
              },
            ),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
      ],
    );
}
