import 'package:flutter/material.dart';
import 'package:movementfarmacy/static/fonts.dart';

class MyText extends StatelessWidget {
  const MyText(
      {super.key,
        this.txt,
        this.color,
        this.fontweight,
        this.size = 20,
        this.family,
        this.lines,
        this.textAlign,
        this.textDecoration, this.overflow=TextOverflow.visible});

  final txt, color, lines, textDecoration, textAlign, family;
  final  FontWeight? fontweight;
  final double size;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    return Text(txt ?? '',
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          color: color ?? Colors.black,
          fontFamily: family ?? Fonts.blackTtf,
          fontSize: size,
          overflow: overflow,
          fontWeight: fontweight ?? FontWeight.w400,
          decoration: textDecoration ?? TextDecoration.none,
        ));
  }
}
