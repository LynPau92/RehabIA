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

  /// Se llama una sola vez, en main.dart, antes de runApp().
  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    // A partir de Android 13, hay que pedir permiso explícito para
    // mostrar notificaciones (antes no hacía falta).
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Programa (o reemplaza) el recordatorio diario a la hora indicada.
  /// Usamos "inexactAllowWhileIdle" a propósito: es menos preciso al
  /// minuto exacto (puede llegar unos minutos después), pero no
  /// requiere el permiso especial de "alarmas exactas" que Android 12+
  /// exige por separado — así mantenemos la configuración simple.
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
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // se repite todos los días
    );
  }

  static Future<void> cancelReminder() async {
    await _plugin.cancel(0);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}