import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../common/theme/toloka_color.dart';
import '../../../common/theme/toloka_fonts.dart';
import '../../../common/widgets/app_text_editing_field.dart';
import '../../registration/ui/data/e_position.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (final previous, final current) =>
              current is ProfileUpdating,
          builder: (final context, final state) {
            final current = context.read<ProfileCubit>().currentUser;
            String selectedPosition = current.position;

            final _ = state as ProfileUpdating;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().cancelEdit(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: TolokaColor.primary,
                        ),
                      ),
                      Text(
                        translate('profile.edit.title'),
                        style: TolokaFonts.big.style,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: GestureDetector(
                      onTap: () => context.read<ProfileCubit>().pickImage(),
                      child: Stack(
                        children: [
                          Center(
                            child: Builder(
                              builder: (final context) {
                                try {
                                  final bytes = base64Decode(state.user.photo);
                                  return Image.memory(
                                    key: UniqueKey(),
                                    bytes,
                                    fit: BoxFit.scaleDown,
                                    errorBuilder:
                                        (final _, final __, final ___) =>
                                            const Icon(Icons.person, size: 75),
                                  );
                                } catch (_) {
                                  return const Icon(Icons.person, size: 75);
                                }
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: MediaQuery.of(context).size.width / 2 - 75,
                            child: IconButton(
                              onPressed: () =>
                                  context.read<ProfileCubit>().pickImage(),
                              style: Theme.of(context)
                                  .iconButtonTheme
                                  .style!
                                  .copyWith(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                  ),
                              icon: const Icon(
                                Icons.edit,
                                color: TolokaColor.primary,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: current.name,
                    decoration: InputDecoration(
                      labelText: translate('profile.edit.name'),
                    ),
                    onChanged: context.read<ProfileCubit>().setName,
                  ),
                  TextFormField(
                    initialValue: current.surname,
                    decoration: InputDecoration(
                      labelText: translate('profile.edit.surname'),
                    ),
                    onChanged: context.read<ProfileCubit>().setSurname,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedPosition,
                    decoration: InputDecoration(
                      labelText: translate('profile.edit.position'),
                    ),
                    items: EPosition.values
                        .map(
                          (final p) => DropdownMenuItem(
                            value: p.name.toLowerCase(),
                            child: Text(p.textWantToBe),
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
                  TextFormField(
                    initialValue: current.about,
                    decoration: InputDecoration(
                      labelText: translate('profile.edit.about'),
                    ),
                    maxLines: 3,
                    onChanged: context.read<ProfileCubit>().setAbout,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: translate('profile.edit.old_password'),
                    ),
                    obscureText: true,
                    onChanged: context.read<ProfileCubit>().setOldPassword,
                  ),
                  AppTextField(
                    controller: _passwordController,
                    label: translate('profile.edit.new_password'),
                    onChanged: context.read<ProfileCubit>().setPassword,
                    option: TextFieldOption.password,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: state.changedUser.about.isNotEmpty &&
                            state.changedUser.name.isNotEmpty &&
                            state.changedUser.surname.isNotEmpty &&
                            selectedPosition.isNotEmpty
                        ? () => context.read<ProfileCubit>().updateProfile()
                        : null,
                    child: Text(translate('profile.edit.save')),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
