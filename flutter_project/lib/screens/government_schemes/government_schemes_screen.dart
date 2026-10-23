import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';

class GovernmentSchemesScreen extends StatelessWidget {
  const GovernmentSchemesScreen({super.key});

  final List<Map<String, dynamic>> _schemes = const [
    {
      'name': 'प्रधानमंत्री किसान सम्मान निधि (PM-KISAN)',
      'benefit': 'सभी पात्र किसान परिवारों को प्रति वर्ष ₹6,000 की वित्तीय सहायता (3 किश्तों में ₹2,000)।',
      'eligibility': 'कृषि योग्य भूमि वाले सभी भूमिधारक किसान परिवार। संस्थागत भूमिधारक पात्र नहीं हैं।',
      'documents': 'आधार कार्ड, बैंक पासबुक, भू-अभिलेख (खसरा-खतौनी), आधार लिंक मोबाइल नंबर।',
      'link': 'https://pmkisan.gov.in',
      'verifiedDate': '2026-10-01',
    },
    {
      'name': 'प्रधानमंत्री फसल बीमा योजना (PMFBY)',
      'benefit': 'प्राकृतिक आपदाओं, सूखा, बाढ़, कीट रोगों से फसल नुकसान पर व्यापक बीमा कवरेज व वित्तीय सुरक्षा।',
      'eligibility': 'अधिसूचित क्षेत्रों में अधिसूचित फसल उगाने वाले बटाईदार व काश्तकार सहित सभी किसान।',
      'documents': 'बुवाई प्रमाण पत्र, भू-स्वामित्व दस्तावेज, बैंक पासबुक, आधार कार्ड।',
      'link': 'https://pmfby.gov.in',
      'verifiedDate': '2026-09-15',
    },
    {
      'name': 'किसान क्रेडिट कार्ड (KCC Scheme)',
      'benefit': 'समय पर ऋण चुकाने पर 4% की रियायती ब्याज दर पर कृषि व संबंधित कार्यों हेतु अल्पकालिक ऋण।',
      'eligibility': 'सभी किसान, काश्तकार, मौखिक पट्टेदार, पशुपालक एवं मत्स्यपालक।',
      'documents': 'आवेदन पत्र, पहचान पत्र, निवास प्रमाण पत्र, जमीन के कागजात।',
      'link': 'https://www.myscheme.gov.in/schemes/kcc',
      'verifiedDate': '2026-08-20',
    },
    {
      'name': 'पीएम कुसुम योजना (PM-KUSUM Solar Pump)',
      'benefit': 'खेतों में सिंचाई हेतु सोलर पंप स्थापना पर केंद्र व राज्य सरकार द्वारा 60% तक का भारी अनुदान।',
      'eligibility': 'व्यक्तिगत किसान, किसानों का समूह, एफपीओ, जल उपभोक्ता संघ।',
      'documents': 'आधार, बैंक विवरण, भूमि दस्तावेज, सिंचाई स्रोत प्रमाण पत्र।',
      'link': 'https://pmkusum.mnre.gov.in',
      'verifiedDate': '2026-10-10',
    },
    {
      'name': 'कृषि यंत्रीकरण उप-मिशन (SMAM Subsidy)',
      'benefit': 'ट्रैक्टर, रोटावेटर, रीपर, लेजर लैंड लेवलर की खरीद पर 40% से 50% तक सरकारी सब्सिडी।',
      'eligibility': 'लघु एवं सीमांत किसान, महिला कृषक, एससी/एसटी किसान प्राथमिकता।',
      'documents': 'जाति प्रमाण पत्र (यदि लागू हो), आधार, बैंक पासबुक, खसरा खतौनी।',
      'link': 'https://agrimachinery.nic.in',
      'verifiedDate': '2026-09-01',
    },
  ];

  Future<void> _openLink(String urlStr) async {
    final uri = Uri.parse(urlStr);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _schemes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final s = _schemes[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _sectionText('लाभ (Benefits)', s['benefit']),
                const SizedBox(height: 8),
                _sectionText('पात्रता (Eligibility)', s['eligibility']),
                const SizedBox(height: 8),
                _sectionText('आवश्यक दस्तावेज', s['documents']),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'सत्यापित: ${s['verifiedDate']}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openLink(s['link']),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('आधिकारिक पोर्टल'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionText(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(desc, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.35)),
      ],
    );
  }
}
