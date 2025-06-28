import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String? name;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? fontSize;
  final double? letterSpacing;

  const CustomTextWidget(
      {super.key,
        this.name,
        this.fontWeight,
        this.color,
        this.fontSize,
        this.letterSpacing,
        this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$name',
      style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
          letterSpacing: letterSpacing,
          // overflow: TextOverflow.ellipsis,
          fontFamily: fontFamily),
    );
  }
}