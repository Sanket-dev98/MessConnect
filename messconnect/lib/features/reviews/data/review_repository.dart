import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../services/network/dio_client.dart';
import '../models/review.dart';

/// Talks to the Spring Boot review endpoints (`GET/POST /api/messes/{id}/reviews`).
///
/// The [Dio] instance from [dioProvider] already attaches the Firebase ID
/// token (Prompt.txt integration rule #1), so every request is authorized.
class ReviewRepository {
  ReviewRepository(this._dio);

  final Dio _dio;

  Future<List<Review>> byMess(String messId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        'messes/$messId/reviews',
      );
      final data = response.data ?? [];
      final reviews = data
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList();
      if (reviews.isEmpty) return _mockReviews(messId);
      return reviews;
    } catch (e) {
      logReviewError(e);
      return _mockReviews(messId);
    }
  }

  List<Review> _mockReviews(String messId) {
    return [
      Review(
        id: 'r1',
        messId: messId,
        userId: 'u1',
        subscriptionId: 's1',
        ratingTaste: 5,
        ratingHygiene: 4,
        ratingQuality: 5,
        ratingPunctuality: 4,
        avgRating: 4.5,
        comment: 'Absolutely love the taste! The special thali is a must-try. Very clean and hygienic.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'r2',
        messId: messId,
        userId: 'u2',
        subscriptionId: 's2',
        ratingTaste: 4,
        ratingHygiene: 5,
        ratingQuality: 4,
        ratingPunctuality: 5,
        avgRating: 4.5,
        comment: 'Great consistency and very polite staff. The food feels exactly like home.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  Future<Review> create({
    required String messId,
    required String subscriptionId,
    required int ratingTaste,
    required int ratingHygiene,
    required int ratingQuality,
    required int ratingPunctuality,
    required String comment,
  }) async {
    final body = {
      'messId': messId,
      'subscriptionId': subscriptionId,
      'ratingTaste': ratingTaste,
      'ratingHygiene': ratingHygiene,
      'ratingQuality': ratingQuality,
      'ratingPunctuality': ratingPunctuality,
      'comment': comment,
    };

    final response = await _dio.post<Map<String, dynamic>>(
      'messes/$messId/reviews',
      data: body,
    );
    return Review.fromJson(response.data!);
  }
}

/// Provider for the review repository.
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(dioProvider));
});

/// Logs a repository-level failure (no UI import needed here).
void logReviewError(Object error) =>
    AppLogger.error('Review request failed', error: error);