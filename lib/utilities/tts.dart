import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_detector/language_detector.dart';

class TTS {
  FlutterTts tts = FlutterTts();

  Future<void> speech(String word) async {
    String language = await LanguageDetector.getLanguageCode(content: word);
    await tts.setLanguage(language);
    tts.speak(word);
  }
}
