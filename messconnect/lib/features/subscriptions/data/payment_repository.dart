import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../services/network/dio_client.dart';
import '../models/payment.dart';

/// Talks to the Spring Boot payment endpoints (`GET/POST /api/payments`).
///
/// Simulated UPI — no real money moves; backend mocks the gateway and returns a
/// `upiRef`.
class PaymentRepository {
  PaymentRepository(this._dio);

  final Dio _dio;

  Future<List<Payment>> myPayments() async {
    final response = await _dio.get<List<dynamic>>('payments');
    final data = response.data ?? [];
    return data
        .map((e) => Payment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Payment> pay({
    required String subscriptionId,
    required double amount,
  }) async {
    final body = {
      'subscriptionId': subscriptionId,
      'amount': amount,
      'paymentMethod': 'UPI',
    };

    final response = await _dio.post<Map<String, dynamic>>(
      'payments',
      data: body,
    );
    return Payment.fromJson(response.data!);
  }
}

/// Provider for the payment repository.
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(dioProvider));
});

/// Logs a repository-level failure.
void logPaymentError(Object error) =>
    AppLogger.error('Payment request failed', error: error);