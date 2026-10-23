class SoilRecord {
  final String id;
  final DateTime testDate;
  final String soilType; // Black, Alluvial, Red, Sandy, Clay
  final double pH;
  final double nitrogenKgPerHa;
  final double phosphorusKgPerHa;
  final double potassiumKgPerHa;
  final double organicCarbonPercent;
  final bool isLabCertified;
  final String recommendations;

  SoilRecord({
    required this.id,
    required this.testDate,
    required this.soilType,
    required this.pH,
    required this.nitrogenKgPerHa,
    required this.phosphorusKgPerHa,
    required this.potassiumKgPerHa,
    required this.organicCarbonPercent,
    required this.isLabCertified,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'testDate': testDate.toIso8601String(),
    'soilType': soilType,
    'pH': pH,
    'nitrogenKgPerHa': nitrogenKgPerHa,
    'phosphorusKgPerHa': phosphorusKgPerHa,
    'potassiumKgPerHa': potassiumKgPerHa,
    'organicCarbonPercent': organicCarbonPercent,
    'isLabCertified': isLabCertified,
    'recommendations': recommendations,
  };
}

class CropCalendarEvent {
  final String id;
  final String cropName;
  final String activityType; // Sowing, Irrigation, Fertilizer, Spray, Harvest
  final DateTime dueDate;
  bool isCompleted;
  final String notes;

  CropCalendarEvent({
    required this.id,
    required this.cropName,
    required this.activityType,
    required this.dueDate,
    this.isCompleted = false,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cropName': cropName,
    'activityType': activityType,
    'dueDate': dueDate.toIso8601String(),
    'isCompleted': isCompleted,
    'notes': notes,
  };
}

class FarmDiaryEntry {
  final String id;
  final DateTime date;
  final String crop;
  final String activity;
  final double expense;
  final String notes;

  FarmDiaryEntry({
    required this.id,
    required this.date,
    required this.crop,
    required this.activity,
    required this.expense,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'crop': crop,
    'activity': activity,
    'expense': expense,
    'notes': notes,
  };
}
