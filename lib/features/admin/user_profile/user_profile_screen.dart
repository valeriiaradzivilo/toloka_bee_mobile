import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import 'bloc/user_profile_bloc.dart';
import 'bloc/user_profile_state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (
          final context,
          final state,
        ) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserProfileError) {
            return Center(child: Text(state.message));
          } else if (state is UserProfileLoaded) {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: [
                      SizedBox.square(
                        dimension: 200,
                        child: Builder(
                          builder: (final context) {
                            try {
                              final bytes =
                                  base64Decode(state.userAuthModel.photo);
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
                      Text('ID: ${state.userAuthModel.id}'),
                      Text(
                        '${state.userAuthModel.name} ${state.userAuthModel.surname}',
                      ),
                      Text(
                        '${translate('profile.email')}: ${state.userAuthModel.email}',
                      ),
                      Text(state.userAuthModel.about),
                      Text(
                        translate(
                          'profile.birth_date',
                          args: {
                            'date': DateFormat.yMMMMEEEEd().format(
                              DateTime.parse(
                                state.userAuthModel.birthDate,
                              ),
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
  //TODO: переглянь чи адмін функції працюють як описано
}
