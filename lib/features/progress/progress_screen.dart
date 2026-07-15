import 'package:flutter/material.dart';

/// Pantalla temporal — la construiremos completa en el Módulo 4
/// (historial de sesiones, gráficas de dolor, rachas).
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progreso')),
      body: const Center(
        child: Text('🚧 Construimos esta pantalla en el Módulo 4.'),
      ),
    );
  }
}