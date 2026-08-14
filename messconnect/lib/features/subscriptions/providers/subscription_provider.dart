import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/payment_repository.dart';
import '../data/subscription_repository.dart';
import '../models/payment.dart';
import '../models/subscription.dart';

/// User's subscriptions (PART 9).
final mySubscriptionsProvider = FutureProvider<List<Subscription>>((ref) async {
  return ref.watch(subscriptionRepositoryProvider).mySubscriptions();
});

/// Provider to find a user's subscription for a specific mess.
///
/// Returns the first subscription (active or previous) for the given messId,
/// or null if none exists. Used to enable the "Write Review" button.
final subscriptionForMessProvider =
    Provider.family<Subscription?, String>((ref, messId) {
  final asyncSubs = ref.watch(mySubscriptionsProvider);
  return asyncSubs.maybeWhen(
    data: (subs) {
      try {
        return subs.firstWhere(
          (s) => s.messId == messId && s.isActiveOrPrevious,
        );
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
});

/// Create a subscription + pay for it in one flow (PART 9).
///
/// Use [ref.read(subscriptionFlowProvider.notifier).subscribe(...)].
final subscriptionFlowProvider =
    AsyncNotifierProvider<SubscriptionFlowNotifier, void>(() {
  return SubscriptionFlowNotifier();
});

class SubscriptionFlowNotifier extends AsyncNotifier<void> {
  @override
  void build() {
    state = const AsyncData(null);
  }

  Future<Payment> subscribe({
    required String messId,
    required String planName,
    required String mealType,
    required String billingCycle,
    required double price,
  }) async {
    state = const AsyncLoading();
    try {
      final sub = await ref
          .watch(subscriptionRepositoryProvider)
          .create(
            messId: messId,
            planName: planName,
            mealType: mealType,
            billingCycle: billingCycle,
            price: price,
          );

      final payment = await ref
          .watch(paymentRepositoryProvider)
          .pay(subscriptionId: sub.id, amount: price);

      state = const AsyncData(null);
      // Refresh subscriptions so UI (e.g. Write Review FAB) updates.
      ref.invalidate(mySubscriptionsProvider);
      return payment;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}