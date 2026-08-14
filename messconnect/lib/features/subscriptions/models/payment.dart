/// Client-side model mirroring the backend [PaymentResponse] (PART 9).
class Payment {
  const Payment({
    required this.id,
    required this.subscriptionId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.upiRef,
    required this.paidAt,
  });

  final String id;
  final String subscriptionId;
  final String userId;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final String upiRef;
  final DateTime paidAt;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      subscriptionId: json['subscriptionId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String,
      upiRef: json['upiRef'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
    );
  }

  bool get isSuccess => status == 'SUCCESS';
}