class CropDoctorResult {
  final String diseaseName;
  final String diseaseNameHindi;
  final double confidence; // e.g. 0.92 = 92%
  final String severity; // Low, Moderate, Severe
  final String causalOrganism; // Fungus, Insect, Bacteria, Nutrient Deficiency
  final List<String> symptoms;
  final List<String> chemicalTreatment;
  final List<String> organicTreatment;
  final List<String> preventionMeasures;
  final String kvkAdvisory;

  CropDoctorResult({
    required this.diseaseName,
    required this.diseaseNameHindi,
    required this.confidence,
    required this.severity,
    required this.causalOrganism,
    required this.symptoms,
    required this.chemicalTreatment,
    required this.organicTreatment,
    required this.preventionMeasures,
    required this.kvkAdvisory,
  });

  factory CropDoctorResult.fromJson(Map<String, dynamic> json) {
    return CropDoctorResult(
      diseaseName: json['diseaseName'] ?? 'Yellow Rust (Puccinia striiformis)',
      diseaseNameHindi: json['diseaseNameHindi'] ?? 'पीला रतुआ (हल्दी रोग)',
      confidence: (json['confidence'] ?? 0.88).toDouble(),
      severity: json['severity'] ?? 'Moderate (मध्यम)',
      causalOrganism: json['causalOrganism'] ?? 'Fungus (कवक)',
      symptoms: List<String>.from(json['symptoms'] ?? [
        'पत्तियों पर पीले रंग की धारियां या पाउडर दिखाई देना',
        'हवा चलने पर पत्तियों से पीला चूर्ण उड़ना',
      ]),
      chemicalTreatment: List<String>.from(json['chemicalTreatment'] ?? [
        'प्रोपिकोनाजोल 25% EC (टिल्ट) @ 1 मिली प्रति लीटर पानी (200 मिली प्रति एकड़) छिड़कें।',
        'टेबुकोनाजोल 25.9% EC @ 1-1.5 मिली प्रति लीटर पानी में मिलाकर स्प्रे करें।',
      ]),
      organicTreatment: List<String>.from(json['organicTreatment'] ?? [
        'खट्टी छाछ (5 लीटर) + 150 ग्राम हींग 200 लीटर पानी में मिलाकर छिड़काव करें।',
        'ट्राइकोडर्मा विरिडी 5 ग्राम प्रति लीटर पानी का छिड़काव करें।',
      ]),
      preventionMeasures: List<String>.from(json['preventionMeasures'] ?? [
        'रोगरोधी किस्मों (जैसे HD 3086, DBW 187, PBW 550) की बुवाई करें।',
        'नाइट्रोजन का अत्यधिक प्रयोग न करें, पोटाश की संतुलित मात्रा दें।',
      ]),
      kvkAdvisory: json['kvkAdvisory'] ?? 'गंभीर प्रकोप की स्थिति में तुरंत नजदीकी कृषि विज्ञान केंद्र (KVK) के पौध संरक्षण वैज्ञानिक से संपर्क करें।',
    );
  }
}
