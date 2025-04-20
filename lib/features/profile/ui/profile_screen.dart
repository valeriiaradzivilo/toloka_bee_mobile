import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

import '../../../common/routing/routes.dart';
import '../../../data/models/user_auth_model.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../bloc/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final _) => ProfileCubit()
          ..loadUser(
            context.read<AuthenticationBloc>().userStream.value.valueOrNull!,
          ),
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
                ProfileErrorState(:final message) =>
                  Center(child: Text(message)),
              },
            ),
          ),
        ),
      );
}

class _LoadedProfile extends StatelessWidget {
  const _LoadedProfile(this.user);
  final UserAuthModel user;

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          CircleAvatar(radius: 40, child: Text(user.name[0])),
          Text(
            '${user.name} ${user.surname}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            user.email,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            '${translate(
              'profile.about',
            )} ${user.about}',
          ),
          Text(
            translate(
              'profile.age',
              args: {
                'age': (DateTime.parse(user.birthDate)
                            .difference(DateTime.now())
                            .inDays ~/
                        365)
                    .abs(),
              },
            ),
          ),
          const Gap(20),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Routes.mainScreen),
            child: Text(translate('profile.actions.back')),
          ),
        ],
      );
}
