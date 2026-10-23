class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String state;
  final String district;
  final String village;
  final double landArea;
  final String landUnit; // Bigha, Acre, Hectare
  final List<String> primaryCrops;
  final String preferredLanguage; // 'hi' or 'en'

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.state,
    required this.district,
    required this.village,
    required this.landArea,
    required this.landUnit,
    required this.primaryCrops,
    required this.preferredLanguage,
  });

  factory UserProfile.defaultProfile() {
    return UserProfile(
      id: 'farmer_01',
      name: 'रामेश्वर पटेल',
      phone: '+91 98765 43210',
      state: 'Madhya Pradesh',
      district: 'Indore',
      village: 'कनाड़िया',
      landArea: 5.0,
      landUnit: 'Acre',
      primaryCrops: ['Wheat (गेहूँ)', 'Soybean (सोयाबीन)', 'Gram (चना)'],
      preferredLanguage: 'hi',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'state': state,
    'district': district,
    'village': village,
    'landArea': landArea,
    'landUnit': landUnit,
    'primaryCrops': primaryCrops,
    'preferredLanguage': preferredLanguage,
  };
}
