import 'dart:ui';

import 'package:flutter/material.dart';

import 'center_widget_clipper.dart';
import 'center_widget_painter.dart';

class CenterWidget extends StatelessWidget {
  final Size size;

  const CenterWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = size.width;
    final height = size.height;

    final path = Path();
    path.moveTo(width, 0.17 * height);
    path.cubicTo(
      0.77 * width,
      0.12 * height,
      0.64 * width,
      0.13 * height,
      0.52 * width,
      0.14 * height,
    );
    path.cubicTo(
      0.4 * width,
      0.15 * height,
      0.09 * width,
      0.23 * height,
      0.06 * width,
      0.34 * height,
    );
    path.cubicTo(
      0.03 * width,
      0.46 * height,
      0.26 * width,
      0.46 * height,
      0.34 * width,
      0.56 * height,
    );
    path.cubicTo(
      0.42 * width,
      0.66 * height,
      0.28 * width,
      0.73 * height,
      0.32 * width,
      0.81 * height,
    );
    path.cubicTo(
      0.37 * width,
      0.89 * height,
      0.55 * width,
      0.97 * height,
      0.7 * width,
      height,
    );
    path.lineTo(width, height);
    path.close;

    return Stack(
      children: [
        CustomPaint(
          painter: CenterWidgetPainter(path: path),
        ),
        ClipPath(
          clipper: CenterWidgetClipper(path: path),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1, -0.6),
                  end: Alignment(1, 0.8),
                  colors: [
                    Color(0x840BB000),
                    Color(0x4D3CD98E),
                    // Color(0x803DE896),
                    // Color(0x4D76E3AE),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}