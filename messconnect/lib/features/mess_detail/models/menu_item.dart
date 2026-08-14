/// A single meal item on a mess's menu (mirrors the future
/// `GET /api/messes/{id}/menu` `MenuResponse` contract, PART 7).
class MenuItem {
  const MenuItem({
    required this.id,
    required this.messId,
    required this.mealType,
    required this.itemName,
    this.dayOfWeek,
    this.description,
    required this.price,
    required this.veg,
  });

  final String id;
  final String messId;
  final String mealType; // BREAKFAST | LUNCH | DINNER | SNACKS
  final int? dayOfWeek; // 0=Sunday .. 6=Saturday
  final String itemName;
  final String? description;
  final double price;
  final bool veg;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      messId: json['messId'] as String,
      mealType: json['mealType'] as String,
      itemName: json['itemName'] as String,
      dayOfWeek: json['dayOfWeek'] as int?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      veg: json['veg'] as bool? ?? true,
    );
  }
}
