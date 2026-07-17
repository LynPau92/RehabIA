import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Un solo "hueso" del skeleton: un rectángulo redondeado que pulsa
/// suavemente entre dos tonos de gris/lila, imitando dónde va a
/// aparecer contenido real una vez que termine de cargar.
///
/// Se usa como pieza de construcción para armar siluetas completas
/// (ver ejemplos en HomeScreen y ExerciseListScreen: en vez de un
/// spinner genérico, mostramos la FORMA aproximada del contenido real
/// — reduce la sensación de espera y evita el "salto" brusco cuando
/// el contenido real aparece).
class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true); // va y viene en bucle, como un "respiro"
    _opacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}