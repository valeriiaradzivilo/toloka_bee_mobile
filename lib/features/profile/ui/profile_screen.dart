import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';

import '../../authentication/bloc/user_bloc.dart';
import '../../registration/ui/data/e_position.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final user = context.read<UserBloc>().userStream.value.valueOrNull!;
    return BlocProvider(
      create: (final _) => ProfileCubit(GetIt.I)..loadUser(user),
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate('profile.edit.title')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (final context, final state) {
              if (state is ProfileUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(translate('profile.edit.success'))),
                );
                Navigator.pop(context);
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (final context, final state) {
              if (state is ProfileLoading || state is ProfileUpdating) {
                return const Center(child: CircularProgressIndicator());
              }

              final current = state is ProfileLoaded
                  ? state.user
                  : (state as ProfileUpdated).user;

              final aboutController =
                  TextEditingController(text: current.about);
              final passwordController = TextEditingController();
              String selectedPosition = current.position;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: '${current.name} ${current.surname}',
                      decoration: InputDecoration(
                        labelText: translate('profile.edit.name'),
                      ),
                      readOnly: true,
                    ),
                    const Gap(16),
                    DropdownButtonFormField<String>(
                      value: selectedPosition,
                      decoration: InputDecoration(
                        labelText: translate('profile.edit.position'),
                      ),
                      items: EPosition.values
                          .map(
                            (final p) => DropdownMenuItem(
                              value: p.name.toLowerCase(),
                              child: Text(p.text),
                            ),
                          )
                          .toList(),
                      onChanged: (final v) {
                        if (v != null) {
                          selectedPosition = v;
                          context.read<ProfileCubit>().setPosition(v);
                        }
                      },
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: aboutController,
                      decoration: InputDecoration(
                        labelText: translate('profile.edit.about'),
                      ),
                      maxLines: 3,
                      onChanged: context.read<ProfileCubit>().setAbout,
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: translate('profile.edit.password'),
                      ),
                      obscureText: true,
                      onChanged: context.read<ProfileCubit>().setPassword,
                    ),
                    const Gap(24),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().updateProfile(),
                      child: Text(translate('profile.edit.save')),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
