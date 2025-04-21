import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../common/routing/routes.dart';
import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../common/widgets/zip_snackbar.dart';
import '../../../data/models/contact_info_model.dart';
import '../../../data/models/request_notification_model.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../authentication/bloc/user_bloc.dart';
import '../../give_hand/ui/widgets/request_tile.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) => Provider(
        create: (final _) => ProfileCubit(GetIt.I)
          ..loadUser(
            context.read<UserBloc>().userStream.value.valueOrNull!,
          ),
        dispose: (final context, final value) => value.close(),
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
                    context.read<ProfileCubit>().loadUser(state.user);
                  }
                },
                builder: (final context, final state) => switch (state) {
                  ProfileUpdated() ||
                  ProfileLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  ProfileLoaded(
                    :final user,
                    :final requests,
                    :final contactInfo
                  ) =>
                    _LoadedProfile(
                      user: user,
                      requests: requests,
                      contactInfo: contactInfo,
                    ),
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
  const _LoadedProfile({
    required this.user,
    required this.requests,
    this.contactInfo,
  });
  final UserAuthModel user;
  final List<RequestNotificationModel> requests;
  final ContactInfoModel? contactInfo;

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
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                translate('profile.requests'),
                style: ZipFonts.medium.style,
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (final _, final index) {
                  final request = requests[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ZipColor.primary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RequestTile(request: request),
                        ),
                        Transform.rotate(
                          angle: 0.2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: request.status.color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              request.status.text,
                              style: ZipFonts.small.style.copyWith(
                                color: ZipColor.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: requests.length,
              ),
            ),
            const Divider(),
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
            Divider(
              color: ZipColor.onSurfaceVariant.withValues(
                alpha: 0.7,
              ),
            ),
            Text(
              translate('profile.contacts.title'),
              style: ZipFonts.medium.style,
            ),
            if (contactInfo == null) ...[
              Text(
                translate('profile.contacts.no'),
                style: ZipFonts.small.style,
              ),
              TextButton.icon(
                onPressed: () => context.read<ProfileCubit>().editUser(),
                label: Text(translate('profile.contacts.add')),
                icon: const Icon(
                  Icons.add,
                  color: ZipColor.primary,
                ),
              ),
            ] else ...[
              if (contactInfo!.phone != null)
                Text(
                  contactInfo!.phone!,
                  style: ZipFonts.small.style,
                ),
              if (contactInfo!.email != null)
                Text(
                  contactInfo!.email!,
                  style: ZipFonts.small.style,
                ),
              if (contactInfo!.viber != null)
                Text(
                  contactInfo!.viber!,
                  style: ZipFonts.small.style,
                ),
              if (contactInfo!.whatsapp != null)
                Text(
                  contactInfo!.whatsapp!,
                  style: ZipFonts.small.style,
                ),
              if (contactInfo!.telegram != null)
                Text(
                  contactInfo!.telegram!,
                  style: ZipFonts.small.style,
                ),
              Text(
                translate(
                  'contacts.preferred',
                  args: {
                    'method': contactInfo!.preferredMethod.text,
                  },
                ),
                style: ZipFonts.small.style,
              ),
            ],
            Divider(
              color: ZipColor.onSurfaceVariant.withValues(
                alpha: 0.7,
              ),
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
