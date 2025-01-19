import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

import '../../../common/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(translate('profile.title')),
          const Gap(20),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, Routes.mainScreen),
              child: Text(translate('profile.actions.back'))),
        ],
      ),
    );
  }
}
