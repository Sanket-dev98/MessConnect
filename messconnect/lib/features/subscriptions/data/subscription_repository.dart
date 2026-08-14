import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../services/network/dio_client.dart';
import '../models/subscription.dart';

/// Talks to the Spring Boot subscription endpoints (`GET/POST /api/subscriptions`).
class SubscriptionRepository {
  SubscriptionRepository(this._dio);

  final Dio _dio;

  Future<List<Subscription>> mySubscriptions() async {
    final response = await _dio.get<List<dynamic>>('subscriptions');
    final data = response.data ?? [];
    return data
        .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Subscription> create({
    required String messId,
    required String planName,
    required String mealType,
    required String billingCycle,
    required double price,
  }) async {
    final body = {
      'messId': messId,
      'planName': planName,
      'mealType': mealType,
      'billingCycle': billingCycle,
      'price': price,
    };

    final response = await _dio.post<Map<String, dynamic>>(
      'subscriptions',
      data: body,
    );
    return Subscription.fromJson(response.data!);
  }
}

/// Provider for the subscription repository.
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(dioProvider));
});

/// Logs a repository-level failure.
void logSubscriptionError(Object error) =>
    AppLogger.error('Subscription request failed', error: error);