import 'package:flutter/material.dart';

import '../../data/models/request_notification_model.dart';
import '../../features/authentication/ui/login_screen.dart';
import '../../features/main_screen/main_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/registration/ui/create_account_screen.dart';
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
        final args = settings.arguments as RequestNotificationModel;
        return MaterialPageRoute(
          builder: (final _) => RequestDetailsScreen(args),
        );
      default:
        return MaterialPageRoute(builder: (final _) => const MainScreen());
    }
  }
}
