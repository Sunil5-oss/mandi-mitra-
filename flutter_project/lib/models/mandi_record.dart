class MandiRecord {
  final String id;
  final String state;
  final String district;
  final String market;
  final String commodity;
  final String variety;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final String arrivalDate;
  final String trend; // 'up', 'down', 'stable'

  MandiRecord({
    required this.id,
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.variety,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.arrivalDate,
    this.trend = 'stable',
  });

  factory MandiRecord.fromJson(Map<String, dynamic> json) {
    return MandiRecord(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      state: json['state'] ?? 'Madhya Pradesh',
      district: json['district'] ?? 'Indore',
      market: json['market'] ?? 'Indore Mandi',
      commodity: json['commodity'] ?? 'Wheat (गेहूँ)',
      variety: json['variety'] ?? 'Lokwan',
      minPrice: (json['min_price'] ?? json['minPrice'] ?? 0).toDouble(),
      maxPrice: (json['max_price'] ?? json['maxPrice'] ?? 0).toDouble(),
      modalPrice: (json['modal_price'] ?? json['modalPrice'] ?? 0).toDouble(),
      arrivalDate: json['arrival_date'] ?? json['arrivalDate'] ?? 'Today',
      trend: json['trend'] ?? 'stable',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'state': state,
    'district': district,
    'market': market,
    'commodity': commodity,
    'variety': variety,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'modalPrice': modalPrice,
    'arrivalDate': arrivalDate,
    'trend': trend,
  };
}

class UniqueKey {
  @override
  String toString() => DateTime.now().millisecondsSinceEpoch.toString();
}
