import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
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
      // Cambiado de "exact" a "alarmClock": Android trata este tipo
      // de alarma exactamente igual que el despertador nativo del
      // teléfono — es el único tipo que prácticamente ningún
      // fabricante (Xiaomi, Tecno, etc.) se atreve a bloquear o
      // retrasar, porque afectaría también a su propia app de reloj.
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // se repite todos los días
    );
  }

  /// DIAGNÓSTICO 1: dispara una notificación de inmediato, sin
  /// programar nada ni esperar ninguna hora. Si esta tampoco aparece,
  /// el problema es de permisos o de que MIUI está bloqueando las
  /// notificaciones de la app — no tiene nada que ver con cómo
  /// calculamos la hora ni con las alarmas exactas.
  static Future<void> showTestNotificationNow() async {
    await _plugin.show(
      999, // ID distinto al del recordatorio real, para no chocar
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
      ),
    );
  }

  /// DIAGNÓSTICO 2: le pregunta al sistema operativo, de verdad, si el
  /// permiso de "alarmas exactas" está concedido en este momento —
  /// en vez de asumir que sí porque en algún momento lo pediste.
  static Future<bool> hasExactAlarmPermission() async {
    final result = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.canScheduleExactNotifications();
    return result ?? false;
  }

  /// DIAGNÓSTICO 3: programa una notificación real (no inmediata, sí
  /// usando zonedSchedule + alarma exacta, igual que el recordatorio
  /// de verdad) para dentro de `seconds` segundos — pero SIN pasar por
  /// nuestro cálculo de hora/minuto (_nextInstanceOfTime). Si esta
  /// SÍ suena, el problema está en ese cálculo. Si esta TAMPOCO suena,
  /// el problema está en cómo usamos zonedSchedule en sí.
  static Future<void> scheduleTestNotificationInSeconds(int seconds) async {
    final scheduledTime = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: seconds));
    await _plugin.zonedSchedule(
      998, // otro ID distinto, para no chocar con el recordatorio real ni la prueba inmediata
      'Notificación programada de prueba ⏰',
      'Si ves esto, zonedSchedule() SÍ funciona — el problema está en el cálculo de hora.',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Notificaciones de prueba',
          channelDescription: 'Canal usado solo para probar que las notificaciones funcionan.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // Sin matchDateTimeComponents: esta es de una sola vez, no diaria.
    );
  }

  /// Revisa si la app YA está excluida de la optimización de batería.
  static Future<bool> isIgnoringBatteryOptimizations() async {
    return await Permission.ignoreBatteryOptimizations.isGranted;
  }

  /// Pide la exclusión de la optimización de batería — la solución
  /// estándar de la industria para que los recordatorios suenen a la
  /// hora en fabricantes agresivos (Xiaomi, Tecno, y varios más). Abre
  /// una pantalla del sistema donde el usuario confirma con un toque.
  static Future<bool> requestIgnoreBatteryOptimizations() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
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