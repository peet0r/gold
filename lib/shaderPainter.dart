import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ShaderWidget extends StatelessWidget{
  const ShaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
     return ShaderBuilder(
        assetKey: 'shaders/simple.frag',
        (context, shader, child) => CustomPaint(size: MediaQuery.of(context).size,
        painter: ShaderPainter(shader: shader, start: DateTime.now()),
        child: const Center(child:CircularProgressIndicator())
     )); 
    }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader, required this.start});
  DateTime start; 
  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size){
    final time = start.millisecondsSinceEpoch.toDouble() / 100000000;
    
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate){
    return true;
  }
}
