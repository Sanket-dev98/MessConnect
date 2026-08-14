/// Client-side model mirroring the backend [ReviewResponse] (PART 8).
///
/// UUID/id and timestamps arrive as strings; ratings are 1-5.
class Review {
  const Review({
    required this.id,
    required this.messId,
    required this.userId,
    required this.subscriptionId,
    required this.ratingTaste,
    required this.ratingHygiene,
    required this.ratingQuality,
    required this.ratingPunctuality,
    required this.avgRating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String messId;
  final String userId;
  final String subscriptionId;
  final int ratingTaste;
  final int ratingHygiene;
  final int ratingQuality;
  final int ratingPunctuality;
  final double avgRating;
  final String comment;
  final DateTime createdAt;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      messId: json['messId'] as String,
      userId: json['userId'] as String,
      subscriptionId: json['subscriptionId'] as String,
      ratingTaste: json['ratingTaste'] as int,
      ratingHygiene: json['ratingHygiene'] as int,
      ratingQuality: json['ratingQuality'] as int,
      ratingPunctuality: json['ratingPunctuality'] as int,
      avgRating: (json['avgRating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}