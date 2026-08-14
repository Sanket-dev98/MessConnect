/// A subscription plan a mess offers (mirrors the future
/// `GET /api/messes/{id}/plans` `PlanResponse` contract, PART 7).
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.planName,
    required this.mealType,
    required this.billingCycle,
    required this.price,
  });

  final String planName;
  final String mealType; // BREAKFAST | LUNCH | DINNER | SNACKS
  final String billingCycle; // DAILY | WEEKLY | MONTHLY
  final double price;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      planName: json['planName'] as String,
      mealType: json['mealType'] as String,
      billingCycle: json['billingCycle'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
