import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';

import '../../../common/routing/routes.dart';
import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../common/widgets/zip_snackbar.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../authentication/bloc/user_bloc.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final _) => ProfileCubit(GetIt.I)
          ..loadUser(
            context.read<UserBloc>().userStream.value.valueOrNull!,
          ),
        child: Scaffold(
          appBar: AppBar(),
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<ProfileCubit, ProfileState>(
                listener: (final context, final state) {
                  if (state is ProfileUpdated) {
                    ZipSnackbar.show(
                      context,
                      PopupModel(
                        title: translate('profile.edit.success'),
                        type: EPopupType.success,
                      ),
                    );
                  }
                },
                builder: (final context, final state) => switch (state) {
                  ProfileLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  ProfileUpdated(:final user) ||
                  ProfileLoaded(:final user) =>
                    _LoadedProfile(user),
                  ProfileError(:final message) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(message),
                          TextButton.icon(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              Routes.mainScreen,
                            ),
                            label: Text(translate('profile.actions.back')),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: ZipColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ProfileUpdating() => const ProfileEditScreen(),
                },
              ),
            ),
          ),
        ),
      );
}

class _LoadedProfile extends StatelessWidget {
  const _LoadedProfile(this.user);
  final UserAuthModel user;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            TextButton.icon(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, Routes.mainScreen),
              label: Text(translate('profile.actions.back')),
              icon: const Icon(
                Icons.arrow_back,
                color: ZipColor.primary,
              ),
            ),
            SizedBox.square(
              dimension: 150,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: MemoryImage(
                      base64Decode(user.photo),
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Text(
              '${user.name} ${user.surname}',
              style: ZipFonts.big.style,
            ),
            Text(
              user.email,
              style: ZipFonts.small.style.copyWith(
                color: ZipColor.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
            Text(
              '${translate(
                'profile.about',
              )} ${user.about}',
              style: ZipFonts.small.style,
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
              style: ZipFonts.small.style,
            ),
            ElevatedButton.icon(
              onPressed: () => context.read<ProfileCubit>().editUser(),
              label: Text(translate('profile.actions.edit')),
              icon: const Icon(
                Icons.edit,
                color: ZipColor.onPrimary,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ZipColor.onErrorContainer,
              ),
              onPressed: () => context.read<ProfileCubit>().editUser(),
              label: Text(translate('profile.actions.delete')),
              icon: const Icon(
                Icons.delete_forever,
                color: ZipColor.onPrimary,
              ),
            ),
            const Gap(20),
          ],
        ),
      );
}
