class KnowledgeCard {
  final String id;
  final String cropName;
  final String title;
  final String problemDescription;
  final String primaryRemedy;
  final String dosage;
  final String precautions;
  final String verifiedSource;
  final DateTime createdAt;

  KnowledgeCard({
    required this.id,
    required this.cropName,
    required this.title,
    required this.problemDescription,
    required this.primaryRemedy,
    required this.dosage,
    required this.precautions,
    required this.verifiedSource,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cropName': cropName,
    'title': title,
    'problemDescription': problemDescription,
    'primaryRemedy': primaryRemedy,
    'dosage': dosage,
    'precautions': precautions,
    'verifiedSource': verifiedSource,
    'createdAt': createdAt.toIso8601String(),
  };
}

class LoanReadinessSummary {
  final String farmerName;
  final String kisanCardNumber;
  final String season; // Rabi 2026, Kharif 2025
  final double landHoldingAcres;
  final double totalCultivationCost;
  final double totalGrossRevenue;
  final double netFarmSurplus;
  final double creditReadinessRatio; // Net income to cost ratio
  final List<String> primaryCrops;

  LoanReadinessSummary({
    required this.farmerName,
    required this.kisanCardNumber,
    required this.season,
    required this.landHoldingAcres,
    required this.totalCultivationCost,
    required this.totalGrossRevenue,
    required this.netFarmSurplus,
    required this.creditReadinessRatio,
    required this.primaryCrops,
  });
}
