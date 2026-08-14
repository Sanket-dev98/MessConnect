import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../services/network/dio_client.dart';
import '../models/mess.dart';

/// Talks to the Spring Boot discovery endpoint (`GET /api/messes`).
///
/// The [Dio] instance from [dioProvider] already attaches the Firebase ID
/// token (Prompt.txt integration rule #1), so every request is authorized.
class MessRepository {
  MessRepository(this._dio);

  final Dio _dio;

  Future<List<Mess>> search({
    String? city,
    String? area,
    String? name,
    double? lat,
    double? lng,
    double? radiusKm,
  }) async {
    // If you want to use the real backend, comment out the line below.
    // return _mockMesses(); 

    try {
      final query = <String, dynamic>{};
      if (city != null && city.isNotEmpty) query['city'] = city;
      if (area != null && area.isNotEmpty) query['area'] = area;
      if (name != null && name.isNotEmpty) query['name'] = name;
      if (lat != null) query['lat'] = lat;
      if (lng != null) query['lng'] = lng;
      if (radiusKm != null) query['radiusKm'] = radiusKm;

      final response = await _dio.get<List<dynamic>>(
        'messes',
        queryParameters: query,
      );
      final data = response.data ?? [];
      final messes = data
          .map((e) => Mess.fromJson(e as Map<String, dynamic>))
          .toList();
      
      // Fallback to mock if empty (for prototype feel)
      if (messes.isEmpty) return _mockMesses();
      return messes;
    } catch (e) {
      logMessError(e);
      // Fallback to mock on error (for prototype feel)
      return _mockMesses();
    }
  }

  List<Mess> _mockMesses() {
    return [
      const Mess(
        id: '1',
        name: 'Annapurna Veg Delight',
        description: 'Special Meal: Unlimited Paneer Thali with Sweet Lassi. We serve authentic home-cooked vegetarian meals with zero preservatives.',
        address: 'Sector 4, Near IT Park, Kothrud',
        area: 'Kothrud',
        city: 'Pune',
        verified: true,
        phone: '+91 98220 12345',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
      ),
      const Mess(
        id: '2',
        name: 'Heritage Home Dining',
        description: 'Special Meal: Traditional Maharashtrian Puran Poli & Katachi Amti. Experience the taste of grandmother\'s recipes in a modern clean environment.',
        address: 'Plot 45, Lane 7, Deccan Gymkhana',
        area: 'Deccan',
        city: 'Pune',
        verified: true,
        phone: '+91 91580 54321',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80',
      ),
    ];
  }
}

/// Provider for the mess repository.
final messRepositoryProvider = Provider<MessRepository>((ref) {
  return MessRepository(ref.watch(dioProvider));
});

/// Logs a repository-level failure (no UI import needed here).
void logMessError(Object error) =>
    AppLogger.error('Mess discovery request failed', error: error);
