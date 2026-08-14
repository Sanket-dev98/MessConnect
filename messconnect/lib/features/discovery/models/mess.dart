/// Client-side model mirroring the backend [MessResponse] (PART 4).
///
/// UUID/id and timestamps arrive as strings; latitude/longitude are nullable
/// because some providers may not have geo-coordinates set.
class Mess {
  const Mess({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.area,
    this.city,
    this.pincode,
    this.latitude,
    this.longitude,
    this.phone,
    this.imageUrl,
    this.verified = false,
  });

  final String id;
  final String name;
  final String? description;
  final String? address;
  final String? area;
  final String? city;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? imageUrl;
  final bool verified;

  factory Mess.fromJson(Map<String, dynamic> json) {
    return Mess(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      area: json['area'] as String?,
      city: json['city'] as String?,
      pincode: json['pincode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      imageUrl: json['imageUrl'] as String?,
      verified: json['verified'] as bool? ?? false,
    );
  }

  /// Short location line, e.g. "Kothrud · Pune".
  String get locationLabel {
    final parts = [area, city].where((e) => e != null && e.isNotEmpty);
    return parts.join(' · ');
  }

  bool get hasLocation => latitude != null && longitude != null;
}
