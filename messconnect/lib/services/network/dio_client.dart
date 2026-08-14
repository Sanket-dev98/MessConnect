import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../services/storage/token_storage.dart';

/// Configured [Dio] instance for talking to the Spring Boot backend.
///
/// For PART 1 this is a baseline: base URL, timeouts, and a request
/// interceptor that injects the Firebase ID token from [TokenStorage] into
/// the `Authorization: Bearer <token>` header. Token refresh wiring lands in
/// PART 3 once Firebase Auth is integrated.
class DioClient {
  DioClient(this._tokenStorage);

  final TokenStorage _tokenStorage;
  late final Dio dio = _create();

  Dio _create() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: Duration(milliseconds: AppConstants.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.readIdToken();
        if (token != null && token.isNotEmpty) {
          options.headers[AppConstants.authHeader] =
              '${AppConstants.bearerPrefix}$token';
        }
        handler.next(options);
      },
    ));
    return dio;
  }
}

/// Provider for the configured [DioClient].
final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return DioClient(storage);
});

/// Convenience provider exposing the underlying [Dio] instance.
final dioProvider = Provider<Dio>((ref) => ref.watch(dioClientProvider).dio);
