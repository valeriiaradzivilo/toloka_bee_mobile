import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../common/reactive/react_widget.dart';
import '../bloc/register_bloc.dart';
import 'data/e_steps.dart';
import 'widget/step_counter.dart';
import 'widget/steps/first_step_create_account.dart';
import 'widget/steps/fourth_step_create_account.dart';
import 'widget/steps/second_step_create_account.dart';
import 'widget/steps/third_step_create_account.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Provider(
          create: (final _) => RegisterBloc(GetIt.I),
          dispose: (final _, final value) => value.dispose(),
          child: const _Screen(),
        ),
      );
}

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(final BuildContext context) {
    final registerBloc = context.read<RegisterBloc>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ReactWidget(
        stream: registerBloc.stepCounterStream,
        builder: (final step) => Column(
          children: [
            StepCounter(
              currentStep: step.index + 1,
              totalSteps: ESteps.values.length,
            ),
            Expanded(
              child: switch (step) {
                ESteps.checkGeneralInfo => const FirstStepCreateAccount(),
                ESteps.addRegisterInfo => const SecondStepCreateAccount(),
                ESteps.addExtraInfo => const ThirdStepCreateAccount(),
                ESteps.addContactInfo => const FourthStepCreateAccount(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
