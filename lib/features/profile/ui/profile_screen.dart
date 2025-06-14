// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../common/routing/routes.dart';
import '../../../common/theme/toloka_color.dart';
import '../../../common/theme/toloka_fonts.dart';
import '../../../common/widgets/toloka_snackbar.dart';
import '../../../data/models/contact_info_model.dart';
import '../../../data/models/request_notification_model.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../authentication/bloc/user_bloc.dart';
import '../../give_hand/ui/widgets/request_tile.dart';
import '../../main_app/main_app.dart';
import '../../registration/ui/data/e_position.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import 'profile_edit_screen.dart';
import 'widgets/profile_contacts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with RouteAware {
  final _profileCubit = ProfileCubit(GetIt.I);

  @override
  void initState() {
    super.initState();
    _profileCubit.loadUser(
      context.read<UserBloc>().userStream.value.valueOrNull!,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MainApp.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    MainApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (_profileCubit.state is ProfileUpdating) return;

    _profileCubit.loadUser(
      context.read<UserBloc>().userStream.value.valueOrNull!,
    );
  }

  @override
  Widget build(final BuildContext context) => Provider(
        create: (final _) => _profileCubit,
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
                    TolokaSnackbar.show(
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
                  ProfileUpdating() => const ProfileEditScreen(),
                  ProfileLoaded(
                    :final user,
                    :final requests,
                    :final contactInfo
                  ) =>
                    _LoadedProfile(
                      user: user,
                      requests: requests,
                      contactInfo: contactInfo,
                      volunteerWorks: state.volunteerWorks,
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
                              color: TolokaColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
    required this.contactInfo,
    required this.volunteerWorks,
  });
  final UserAuthModel user;
  final List<RequestNotificationModel> requests;
  final ContactInfoModel? contactInfo;
  final List<RequestNotificationModel> volunteerWorks;

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
                color: TolokaColor.primary,
              ),
            ),
            SizedBox.square(
              dimension: 150,
              child: Builder(
                builder: (final context) {
                  try {
                    final bytes = base64Decode(user.photo);
                    return Image.memory(
                      bytes,
                      fit: BoxFit.scaleDown,
                      errorBuilder: (final _, final __, final ___) =>
                          const Icon(Icons.person, size: 75),
                    );
                  } catch (_) {
                    return const Icon(Icons.person, size: 75);
                  }
                },
              ),
            ),
            Text(
              '${user.name} ${user.surname}',
              style: TolokaFonts.big.style,
            ),
            Text(
              user.email,
              style: TolokaFonts.small.style.copyWith(
                color: TolokaColor.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
            if (EPosition.fromJson(user.position) case final EPosition position)
              Text(
                position.text,
                style: TolokaFonts.small.style.copyWith(
                  color: TolokaColor.secondary,
                ),
              ),
            if (requests.isNotEmpty) ...[
              const Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  translate('profile.requests'),
                  style: TolokaFonts.medium.style,
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (final _, final index) => RequestTile(
                    request: requests[index],
                    width: MediaQuery.sizeOf(context).width - 50,
                  ),
                  itemCount: requests.length,
                ),
              ),
            ],
            _VolunteerWork(volunteerWorks),
            const Divider(),
            ProfileContacts(
              contactInfo: contactInfo,
            ),
            Divider(
              color: TolokaColor.onSurfaceVariant.withValues(
                alpha: 0.7,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${translate(
                  'profile.about',
                )} ${user.about}',
                style: TolokaFonts.small.style,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
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
                style: TolokaFonts.small.style,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => context.read<ProfileCubit>().editUser(),
              label: Text(translate('profile.actions.edit')),
              icon: const Icon(
                Icons.edit,
                color: TolokaColor.onPrimary,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: TolokaColor.onErrorContainer,
              ),
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (final context) => AlertDialog(
                    title: Text(translate('profile.actions.delete')),
                    content: Text(translate('profile.actions.delete.confirm')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(translate('common.cancel')),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(translate('common.delete')),
                      ),
                    ],
                  ),
                );
                if (shouldDelete != true) return;

                await context.read<ProfileCubit>().deleteUser();

                await Navigator.pushReplacementNamed(
                  context,
                  Routes.mainScreen,
                );
              },
              label: Text(translate('profile.actions.delete')),
              icon: const Icon(
                Icons.delete_forever,
                color: TolokaColor.onPrimary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
}

class _VolunteerWork extends StatelessWidget {
  const _VolunteerWork(this.volunteerWorks);
  final List<RequestNotificationModel> volunteerWorks;

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (volunteerWorks.isNotEmpty) ...[
            Text(
              translate('profile.volunteer_work'),
              style: TolokaFonts.medium.style,
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemBuilder: (final _, final index) => RequestTile(
                  request: volunteerWorks[index],
                  width: MediaQuery.sizeOf(context).width - 50,
                ),
                itemCount: volunteerWorks.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ],
      );
}
