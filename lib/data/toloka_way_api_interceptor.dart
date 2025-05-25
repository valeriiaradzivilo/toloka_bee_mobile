import 'package:dio/dio.dart';
import 'package:simple_logger/simple_logger.dart';

import 'di.dart';
import 'source/authentication/auth_data_source.dart';

class TolokaWayApiInterceptor extends Interceptor {
  final SimpleLogger logger = SimpleLogger();

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    try {
      const noAuthPaths = '/auth';
      final requiresAccessToken = !options.path.contains(noAuthPaths);

      final authDataSource = serviceLocator<AuthDataSource>();

      if (requiresAccessToken) {
        if (options.path.contains('fcm.googleapis.com')) {
          final token = await authDataSource.getFirebaseMessagingAccessToken();

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            options.headers['Content-Type'] = 'application/json';
          } else {
            logger.warning('Access token is empty');
          }
        } else {
          final idToken = await authDataSource.getUserIdToken();

          if (idToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $idToken';
            options.headers['Content-Type'] = 'application/json';
          } else {
            logger.warning('Access token is empty');
          }
        }
      }
    } catch (e) {
      logger.warning('Failed to get access token: $e');
    }

    super.onRequest(options, handler);
  }
}
