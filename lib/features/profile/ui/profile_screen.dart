import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

import '../../../common/routes.dart';
import '../../../data/models/user_model.dart';
import '../bloc/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider(
      //TODO: THIS IS A CRUTCH, REMOVE IT
      create: (final _) => ProfileCubit()..loadUser(UserModel.test()),
      child: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (final context, final state) => switch (state) {
              ProfileLoadingState() ||
              ProfileInitialState() =>
                const Center(child: CircularProgressIndicator()),
              ProfileLoadedState(:final user) => _LoadedProfile(user),
              ProfileErrorState(:final message) => Center(child: Text(message)),
            },
          ),
        ),
      ),
    );
}

class _LoadedProfile extends StatelessWidget {
  const _LoadedProfile(this.user);
  final UserModel user;

  @override
  Widget build(final BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(radius: 40, child: Text(user.name[0])),
        const Gap(20),
        Text(
          '${user.name} ${user.surname}',
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          '@${user.username}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const Gap(40),
        TextButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.mainScreen),
          child: Text(translate('profile.actions.back')),
        ),
      ],
    );
}
