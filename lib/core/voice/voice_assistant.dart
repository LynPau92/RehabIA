import 'package:flutter_tts/flutter_tts.dart';

/// Envuelve flutter_tts en un solo lugar, con el idioma y velocidad ya
/// configurados para RehabIA. El resto de la app solo llama a
/// `VoiceAssistant.speak(...)`, sin preocuparse por la configuración.
class VoiceAssistant {
  VoiceAssistant._();

  static final _tts = FlutterTts();
  static bool _initialized = false;
  static bool enabled = true; // controlado por el botón de silenciar
  static bool _isSpeaking = false; // sabemos si hay algo sonando ahora mismo

  static Future<void> init() async {
    if (_initialized) return;
    await _tts.setLanguage('es-419'); // español latinoamericano
    await _tts.setSpeechRate(0.48); // un poco más lento que el default, para claridad
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    // Nos avisan cuándo empieza y termina de hablar, para saber si es
    // seguro dejar pasar un mensaje de baja prioridad sin interrumpir.
    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);
    _tts.setErrorHandler((msg) => _isSpeaking = false);

    _initialized = true;
  }

  /// Aplica la velocidad y volumen guardados en el perfil del usuario.
  /// Se llama al abrir la app y cada vez que el usuario cambia estos
  /// valores en Ajustes.
  static Future<void> applyPreferences({required double rate, required double volume}) async {
    await _tts.setSpeechRate(rate);
    await _tts.setVolume(volume);
  }

  /// Dice un texto en voz alta.
  ///
  /// `interrupt: true` (default) — para mensajes importantes (nombre
  /// del ejercicio, felicitación final): cortan lo que esté sonando.
  ///
  /// `interrupt: false` — para avisos secundarios (recordatorio de
  /// postura, "mantén la posición"): si ya hay algo sonando, este
  /// mensaje simplemente se OMITE en vez de cortar lo anterior — la
  /// próxima vez que se evalúe (una fracción de segundo después) se
  /// vuelve a intentar.
  static Future<void> speak(String text, {bool interrupt = true}) async {
    if (!enabled) return;
    if (!interrupt && _isSpeaking) return;
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  static void toggle() {
    enabled = !enabled;
    if (!enabled) _tts.stop();
  }
}