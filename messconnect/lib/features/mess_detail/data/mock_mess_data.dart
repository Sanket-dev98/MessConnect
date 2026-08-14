import '../../../core/constants/app_constants.dart';
import '../models/menu_item.dart';
import '../../subscriptions/models/subscription_plan.dart';

/// PART 7 mock data layer.
///
/// Mirrors the exact shape the future backend endpoints will return (see the
/// API contract in the Part 7 plan). Keyed by messId so each mess could show
/// different content; a fallback is returned for any unknown id so the UI
/// always renders. Replace with real `GET`s by flipping
/// [AppConstants.useMockMessData] off in `mess_detail_repository.dart`.
Map<String, List<MenuItem>> get mockMenus => {
  _fallbackKey: [
    MenuItem(
      id: 'm-bf-1',
      messId: _fallbackKey,
      mealType: 'BREAKFAST',
      itemName: 'Poha & Tea',
      description: 'Flattened rice with peanuts and a cup of tea.',
      price: 40,
      veg: true,
    ),
    MenuItem(
      id: 'm-ln-1',
      messId: _fallbackKey,
      mealType: 'LUNCH',
      itemName: 'Thali (2 Roti, Rice, Dal, Sabzi)',
      description: 'Unlimited dal-rice with two rotis and seasonal veg.',
      price: 90,
      veg: true,
    ),
    MenuItem(
      id: 'm-dn-1',
      messId: _fallbackKey,
      mealType: 'DINNER',
      itemName: 'Paneer Curry & Rice',
      description: 'Cottage cheese curry with jeera rice.',
      price: 110,
      veg: true,
    ),
    MenuItem(
      id: 'm-sn-1',
      messId: _fallbackKey,
      mealType: 'SNACKS',
      itemName: 'Vada Pav',
      description: 'Mumbai-style potato fritter bun.',
      price: 25,
      veg: true,
    ),
  ],
};

Map<String, List<SubscriptionPlan>> get mockPlans => {
  _fallbackKey: [
    SubscriptionPlan(
      planName: 'Monthly Veg Lunch',
      mealType: 'LUNCH',
      billingCycle: 'MONTHLY',
      price: 2400,
    ),
    SubscriptionPlan(
      planName: 'Daily Breakfast',
      mealType: 'BREAKFAST',
      billingCycle: 'DAILY',
      price: 40,
    ),
    SubscriptionPlan(
      planName: 'Weekly Full Diet',
      mealType: 'DINNER',
      billingCycle: 'WEEKLY',
      price: 630,
    ),
  ],
};

/// Returns mock menus for [messId], falling back to the shared sample set.
List<MenuItem> mockMenuFor(String messId) =>
    mockMenus[messId] ?? mockMenus[_fallbackKey]!;

/// Returns mock plans for [messId], falling back to the shared sample set.
List<SubscriptionPlan> mockPlansFor(String messId) =>
    mockPlans[messId] ?? mockPlans[_fallbackKey]!;

const String _fallbackKey = '__default__';
