import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

class TTS {
  FlutterTts tts = FlutterTts();

  Future<void> speech(String word) async {
    await langdetect.initLangDetect();
    String language = langdetect.detect(word);
    print(language);
    await tts.setLanguage(language);
    tts.speak(word);
  }
}
