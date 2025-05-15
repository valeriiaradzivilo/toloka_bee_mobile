import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../common/routing/routes.dart';
import '../../bloc/register_bloc.dart';
import '../data/e_steps.dart';

class NextBackButtonRow extends StatelessWidget {
  const NextBackButtonRow({
    super.key,
    required this.step,
    required this.areFieldsValid,
    this.canGoToTheNextStep,
  });
  final ESteps step;
  final bool areFieldsValid;
  final bool Function()? canGoToTheNextStep;

  @override
  Widget build(final BuildContext context) {
    final registerBloc = context.read<RegisterBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        ...switch (step) {
          _ when step.nextStep != null && step.previousStep != null => [
              ElevatedButton(
                onPressed: () => registerBloc.previousStep(),
                child: Text(translate('create.account.back')),
              ),
              ElevatedButton(
                onPressed: areFieldsValid
                    ? () {
                        final canGo = canGoToTheNextStep != null
                            ? canGoToTheNextStep!()
                            : true;
                        if (canGo) {
                          registerBloc.nextStep();
                        }
                      }
                    : null,
                child: Text(translate('create.account.next')),
              ),
            ],
          _ when step.nextStep != null => [
              ElevatedButton(
                onPressed: areFieldsValid
                    ? () {
                        final canGo = canGoToTheNextStep != null
                            ? canGoToTheNextStep!()
                            : true;
                        if (canGo) {
                          registerBloc.nextStep();
                        }
                      }
                    : null,
                child: Text(translate('create.account.next')),
              ),
            ],
          _ when step.previousStep != null => [
              ElevatedButton(
                onPressed: () => registerBloc.previousStep(),
                child: Text(translate('create.account.back')),
              ),
              ElevatedButton(
                onPressed: areFieldsValid
                    ? () {
                        final canGo = canGoToTheNextStep != null
                            ? canGoToTheNextStep!()
                            : true;
                        if (canGo) {
                          registerBloc.register();
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.loginScreen);
                        }
                      }
                    : null,
                child: Text(translate('create.account.register')),
              ),
            ],
          _ => [],
        },
      ],
    );
  }
}
