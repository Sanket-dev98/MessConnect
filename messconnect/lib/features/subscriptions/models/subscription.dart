/// Client-side model mirroring the backend [SubscriptionResponse] (PART 9).
class Subscription {
  const Subscription({
    required this.id,
    required this.userId,
    required this.messId,
    required this.planName,
    required this.mealType,
    required this.billingCycle,
    required this.price,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String messId;
  final String planName;
  final String mealType;
  final String billingCycle;
  final double price;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      messId: json['messId'] as String,
      planName: json['planName'] as String,
      mealType: json['mealType'] as String,
      billingCycle: json['billingCycle'] as String,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  bool get isActiveOrPrevious =>
      status == 'ACTIVE' || status == 'EXPIRED' || status == 'CANCELLED';
}