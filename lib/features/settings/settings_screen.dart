import 'package:flutter/material.dart';

/// Pantalla temporal — ajustes de accesibilidad (Módulo 6): tamaño de
/// texto, volumen del asistente de voz, notificaciones.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: const Center(
        child: Text('🚧 Construimos esta pantalla en el Módulo 6.'),
      ),
    );
  }
}