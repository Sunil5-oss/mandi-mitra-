import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class GeminiService {
  Future<String> askAssistant({
    required String prompt,
    String language = 'hi',
    String? base64Image,
    List<Map<String, String>>? history,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.chatEndpoint}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'language': language,
          'image': base64Image,
          'history': history ?? [],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? 'उत्तर प्राप्त नहीं हो सका। कृपया पुनः प्रयास करें।';
      } else {
        return 'सर्वर से संपर्क नहीं हो पाया (त्रुटि कोड: ${response.statusCode})। कृपया अपना इंटरनेट कनेक्शन जांचें।';
      }
    } catch (e) {
      return 'एआई सहायक सेवा अभी उपलब्ध नहीं है: $e। कृपया कुछ समय बाद पुनः प्रयास करें।';
    }
  }
}
