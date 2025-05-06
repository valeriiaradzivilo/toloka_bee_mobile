import 'package:dio/dio.dart';
import 'package:simple_logger/simple_logger.dart';

import 'di.dart';
import 'source/authentication/auth_data_source.dart';

class ZipWayApiInterceptor extends Interceptor {
  final SimpleLogger logger = SimpleLogger();

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    try {
      final noAuthPaths = '/auth';
      final requiresAccessToken = !options.path.contains(noAuthPaths);

      if (requiresAccessToken) {
        final authDataSource = serviceLocator<AuthDataSource>();
        final token = await authDataSource.getAccessToken();

        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          logger.warning('Access token is empty');
        }
      }
    } catch (e) {
      logger.warning('Failed to get access token: $e');
    }

    super.onRequest(options, handler);
  }
}
