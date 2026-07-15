import 'package:flutter/material.dart';

/// Pantalla temporal — mostrará los datos del perfil, editables,
/// y el historial de lesiones.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: const Center(
        child: Text('🚧 Construimos esta pantalla más adelante.'),
      ),
    );
  }
}