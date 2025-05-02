import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/admin/user_profile/bloc/user_profile_bloc.dart';
import '../../features/admin/user_profile/bloc/user_profile_event.dart';
import '../../features/admin/user_profile/user_profile_screen.dart';
import '../../features/authentication/ui/login_screen.dart';
import '../../features/main_screen/main_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/registration/ui/create_account_screen.dart';
import '../../features/request_details/bloc/request_details_bloc.dart';
import '../../features/request_details/bloc/request_details_event.dart';
import '../../features/request_details/ui/request_details_screen.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generate(final RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (final _) => const LoginScreen());
      case Routes.createAccountScreen:
        return MaterialPageRoute(
          builder: (final _) => const CreateAccountScreen(),
        );
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (final _) => const ProfileScreen());
      case Routes.requestDetailsScreen:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (final _) => BlocProvider(
            create: (final _) => RequestDetailsBloc(GetIt.I)
              ..add(
                FetchRequestDetails(args),
              ),
            child: const RequestDetailsScreen(),
          ),
        );

      case Routes.adminUserProfile:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (final _) => BlocProvider(
            create: (final _) => UserProfileBloc(GetIt.I)
              ..add(
                GetUserProfileEvent(args),
              ),
            child: const UserProfileScreen(),
          ),
        );

      default:
        return MaterialPageRoute(builder: (final _) => const MainScreen());
    }
  }
}
