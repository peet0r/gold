import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class TexturedWidget extends StatefulWidget {
  const TexturedWidget({super.key});

  @override
  State<TexturedWidget> createState()=> _TexturedWidgetState();
}

class _TexturedWidgetState extends State<TexturedWidget> {
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
        assetKey: 'shaders/textured.frag',
        (context, shader, child) => CustomPaint(size: MediaQuery.of(context).size,
        painter: TexturePainter(shader, [image]), 
     )); }
  }
}


class TexturePainter extends CustomPainter {
 final ui.FragmentShader shader;
  final List<ui.Image?> images;

  TexturePainter(FragmentShader fragmentShader, this.images)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < images.length; i++) {
      shader.setImageSampler(i, images[i]!);
    }
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    final paint = Paint();

    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;}
