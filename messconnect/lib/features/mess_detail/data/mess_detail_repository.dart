import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../services/network/dio_client.dart';
import '../../discovery/models/mess.dart';
import '../models/menu_item.dart';
import '../../subscriptions/models/subscription_plan.dart';
import 'mock_mess_data.dart';

/// Detail-screen data source for a single mess (PART 7).
///
/// - `getMess` hits the REAL `GET /api/messes/{id}` endpoint (exists in PART 4).
/// - `getMenu` / `getPlans` use the local mock layer while the backend has no
///   such endpoints; flip [AppConstants.useMockMessData] to use real `GET`s
///   (`messes/{id}/menu`, `messes/{id}/plans`) once they exist.
class MessDetailRepository {
  MessDetailRepository(this._dio);

  final Dio _dio;

  Future<Mess> getMess(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('messes/$id');
    return Mess.fromJson(response.data!);
  }

  Future<List<MenuItem>> getMenu(String messId) async {
    if (!AppConstants.useMockMessData) {
      final response =
          await _dio.get<List<dynamic>>('messes/$messId/menu');
      return (response.data ?? [])
          .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return mockMenuFor(messId);
  }

  Future<List<SubscriptionPlan>> getPlans(String messId) async {
    if (!AppConstants.useMockMessData) {
      final response =
          await _dio.get<List<dynamic>>('messes/$messId/plans');
      return (response.data ?? [])
          .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return mockPlansFor(messId);
  }
}

/// Provider for the mess-detail repository.
final messDetailRepositoryProvider = Provider<MessDetailRepository>((ref) {
  return MessDetailRepository(ref.watch(dioProvider));
});
