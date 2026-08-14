/// App-wide constants (names, endpoints, defaults).
///
/// Backend base URL will be wired in PART 5 (Frontend Core). Kept here so
/// every layer reads from a single source of truth.
class AppConstants {
  const AppConstants._();

  static const String appName = 'MessConnect';

  /// Base URL for the Spring Boot REST API.
  /// TODO(PART 5): swap for a real/local emulator address.
  static const String apiBaseUrl = 'http://10.0.2.2:8080/api';

  /// Connection/read timeouts for the Dio client.
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 30000;

  /// Authorization header used to carry the Firebase ID token.
  static const String authHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  /// PART 6 placeholder map center. TODO: replace with your college
  /// lat/lng (provided later) so the base map opens on campus.
  static const double mapDefaultLat = 0.0;
  static const double mapDefaultLng = 0.0;
  static const double mapDefaultZoom = 11.0;

  /// PART 7: when true, menus + subscription plans are served from the local
  /// mock layer (the backend has no such endpoints yet). Flip to false once the
  /// `GET /api/messes/{id}/menu` and `/plans` endpoints exist. The real
  /// `GET /api/messes/{id}` detail is always live.
  static const bool useMockMessData = true;
}
