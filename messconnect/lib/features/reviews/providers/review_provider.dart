import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/review_repository.dart';
import '../models/review.dart';

/// Reviews for a given mess (PART 8).
///
/// `FutureProvider.family` so the detail screen can watch them
/// independently by mess id.
final reviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, messId) async {
  return ref.watch(reviewRepositoryProvider).byMess(messId);
});

/// Async value notifier for creating a review (POST).
///
/// Use [ref.read(reviewCreateProvider.notifier).create(...)] from widgets.
final reviewCreateProvider =
    AsyncNotifierProvider<ReviewCreateNotifier, void>(() {
  return ReviewCreateNotifier();
});

class ReviewCreateNotifier extends AsyncNotifier<void> {
  @override
  void build() {
    state = const AsyncData(null);
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
    state = const AsyncLoading();
    try {
      final review = await ref
          .watch(reviewRepositoryProvider)
          .create(
            messId: messId,
            subscriptionId: subscriptionId,
            ratingTaste: ratingTaste,
            ratingHygiene: ratingHygiene,
            ratingQuality: ratingQuality,
            ratingPunctuality: ratingPunctuality,
            comment: comment,
          );
      state = const AsyncData(null);
      // Invalidate reviews for this mess so the list refreshes
      ref.invalidate(reviewsProvider(messId));
      return review;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}