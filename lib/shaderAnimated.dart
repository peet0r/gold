import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class SAnimatedWidget extends StatefulWidget {
  const SAnimatedWidget({super.key});

  @override
  State<SAnimatedWidget> createState()=> _SAnimatedWidgetState();
}

class _SAnimatedWidgetState extends State<SAnimatedWidget> {
  double time =  DateTime.now().millisecondsSinceEpoch.toDouble() / 100000000;
  ui.Image? image;
  TickerFuture? ticker;
  @override
  void initState() {
    super.initState();
    ticker = Ticker((d){
      final now = DateTime.now();
      setState(() {
            time = sin(now.second.toDouble() + (now.millisecond.toDouble()/1000));  
            });
    }).start();
    load();
}

  void load() async {
      final imageData = await rootBundle.load('assets/derp.jpeg');
      image = await decodeImageFromList(imageData.buffer.asUint8List());
      setState(() {
              
            });
  }

  @override
  Widget build(BuildContext context) {
    if(image == null){
    return const CircularProgressIndicator();} else{
      return ShaderBuilder(
        assetKey: 'shaders/simple.frag',
        (context, shader, child) => CustomPaint(child: SizedBox.expand(),
        painter: AnimatedPainter(shader: shader, start:time), 
     )); }
  }
}


class AnimatedPainter extends CustomPainter {
  AnimatedPainter({required this.shader, required this.start});
  double start; 
  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size){
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, start);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate){
    return true;
  }
}
