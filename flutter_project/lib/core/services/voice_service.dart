import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speech = SpeechToText();
  bool _isSpeechInitialized = false;

  Future<void> initVoice() async {
    try {
      _isSpeechInitialized = await _speech.initialize();
      await _tts.setLanguage('hi-IN');
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.85);
    } catch (_) {}
  }

  Future<void> speak(String text, {String language = 'hi'}) async {
    try {
      await _tts.setLanguage(language == 'hi' ? 'hi-IN' : 'en-US');
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required Function() onListeningComplete,
  }) async {
    if (!_isSpeechInitialized) {
      _isSpeechInitialized = await _speech.initialize();
    }
    if (_isSpeechInitialized) {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
          if (result.finalResult) {
            onListeningComplete();
          }
        },
        localeId: 'hi_IN',
      );
    }
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
