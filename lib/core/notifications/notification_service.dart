import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Envuelve todo lo relacionado con notificaciones locales en un solo
/// lugar. El resto de la app no necesita saber cómo funciona
/// `flutter_local_notifications` por dentro — solo llama a estos
/// métodos.
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Se llama una sola vez, en main.dart, antes de runApp(). Es
  /// rápido a propósito — NO pide ningún permiso aquí, solo prepara
  /// el plugin. Antes pedíamos el permiso de notificaciones en este
  /// mismo paso, y eso bloqueaba el arranque de la app esperando que
  /// el usuario respondiera el diálogo del sistema, haciendo que el
  /// splash se sintiera lento.
  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  /// Pide el permiso de notificaciones (Android 13+). Se llama SOLO
  /// cuando el usuario activa el recordatorio en Ajustes — así el
  /// diálogo del sistema aparece en un momento con contexto ("estoy
  /// activando recordatorios"), no de sorpresa al abrir la app.
  static Future<bool> requestPermission() async {
    final granted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return granted ?? true; // iOS/versiones viejas de Android: no hace falta pedirlo
  }

  /// Pide el permiso de "alarmas exactas" (Android 12+). Sin esto, el
  /// sistema puede retrasar el recordatorio 15-60 minutos para ahorrar
  /// batería — inaceptable para algo tan importante como no perderse
  /// la sesión de rehabilitación del día. Abre una pantalla de Ajustes
  /// del sistema donde el usuario activa un interruptor.
  static Future<bool> requestExactAlarmPermission() async {
    final granted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    return granted ?? true;
  }

  /// Programa (o reemplaza) el recordatorio diario a la hora indicada.
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _plugin.zonedSchedule(
      0, // ID fijo: solo tenemos un recordatorio, así que siempre lo reemplaza
      'Hora de tu rehabilitación 💪',
      'Tu sesión de ejercicios de hoy te está esperando en RehabIA.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Recordatorio diario de ejercicios',
          channelDescription: 'Te avisa todos los días a la hora que elijas.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      // Cambiado de "inexact" a "exact": para un recordatorio de
      // salud, preferimos pedir el permiso extra a cambio de que
      // suene a la hora que el paciente eligió, no "en algún momento
      // cercano".
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // se repite todos los días
    );
  }

  static Future<void> cancelReminder() async {
    await _plugin.cancel(0);
  }

  /// Calcula el próximo momento en que debe sonar el recordatorio.
  ///
  /// A diferencia del intento anterior (que necesitaba el plugin
  /// flutter_timezone para saber "en qué zona horaria estás"), aquí
  /// usamos SOLO herramientas que ya vienen con Dart:
  ///   1. `DateTime.now()` nos da la hora local del celular tal cual
  ///      el sistema operativo la interpreta — sin necesitar saber el
  ///      nombre de la zona horaria (ej. "America/Santo_Domingo").
  ///   2. `.toUtc()` convierte ese momento a UTC, algo que Dart hace
  ///      correctamente por su cuenta usando la configuración del
  ///      propio dispositivo.
  ///   3. Construimos el TZDateTime que pide flutter_local_notifications
  ///      directamente en UTC — así evitamos por completo necesitar
  ///      configurar tz.local (que fue la causa del bug original) y
  ///      también evitamos el plugin que rompía la compilación.
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final nowLocal = DateTime.now();
    var scheduledLocal = DateTime(nowLocal.year, nowLocal.month, nowLocal.day, hour, minute);
    if (scheduledLocal.isBefore(nowLocal)) {
      scheduledLocal = scheduledLocal.add(const Duration(days: 1));
    }
    return tz.TZDateTime.from(scheduledLocal.toUtc(), tz.UTC);
  }
}