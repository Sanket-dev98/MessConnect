import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mess_detail_repository.dart';
import '../models/menu_item.dart';
import '../../subscriptions/models/subscription_plan.dart';
import '../../discovery/models/mess.dart';

/// Single mess + its menu + plans, keyed by mess id (PART 7).
///
/// Each is a `FutureProvider.family` so the detail screen can watch them
/// independently (the mess loads from the real API; menu/plans from the mock
/// layer while the backend catches up).
final messDetailProvider =
    FutureProvider.family<Mess, String>((ref, id) async {
  return ref.watch(messDetailRepositoryProvider).getMess(id);
});

final menuProvider =
    FutureProvider.family<List<MenuItem>, String>((ref, id) async {
  return ref.watch(messDetailRepositoryProvider).getMenu(id);
});

final plansProvider =
    FutureProvider.family<List<SubscriptionPlan>, String>((ref, id) async {
  return ref.watch(messDetailRepositoryProvider).getPlans(id);
});
