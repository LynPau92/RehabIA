import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Envuelve todo lo relacionado con notificaciones locales en un solo lugar.
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Inicializa el plugin configurando tanto Android como iOS.
  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // --- CONFIGURACIÓN PARA iOS / macOS ---
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings);
  }

  /// Pide el permiso de notificaciones tanto en Android 13+ como en iOS.
  static Future<bool> requestPermission() async {
    // Permisos Android
    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Permisos iOS
    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Pide el permiso de "alarmas exactas" (Android 12+).
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
      0,
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
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Dispara una notificación de prueba de inmediato.
  static Future<void> showTestNotificationNow() async {
    await _plugin.show(
      999,
      'Notificación de prueba 🔔',
      'Si ves esto, las notificaciones básicas SÍ funcionan.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Notificaciones de prueba',
          channelDescription: 'Canal usado solo para probar que las notificaciones funcionan.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// Revisa si el permiso de alarmas exactas está concedido (Android).
  static Future<bool> hasExactAlarmPermission() async {
    final result = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.canScheduleExactNotifications();
    return result ?? true;
  }

  /// Programa una notificación de prueba para dentro de X segundos.
  static Future<void> scheduleTestNotificationInSeconds(int seconds) async {
    final scheduledTime = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: seconds));
    await _plugin.zonedSchedule(
      998,
      'Notificación programada de prueba ⏰',
      'Si ves esto, zonedSchedule() SÍ funciona en tu dispositivo.',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Notificaciones de prueba',
          channelDescription: 'Canal usado solo para probar que las notificaciones funcionan.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<bool> isIgnoringBatteryOptimizations() async {
    return await Permission.ignoreBatteryOptimizations.isGranted;
  }

  static Future<bool> requestIgnoreBatteryOptimizations() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }

  static Future<void> cancelReminder() async {
    await _plugin.cancel(0);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final nowLocal = DateTime.now();
    var scheduledLocal = DateTime(nowLocal.year, nowLocal.month, nowLocal.day, hour, minute);
    if (scheduledLocal.isBefore(nowLocal)) {
      scheduledLocal = scheduledLocal.add(const Duration(days: 1));
    }
    return tz.TZDateTime.from(scheduledLocal.toUtc(), tz.UTC);
  }
}