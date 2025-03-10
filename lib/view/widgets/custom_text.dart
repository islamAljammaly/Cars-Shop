import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double fontSize;

  final Color color;
  final FontWeight fontWeight;

  final Alignment alignment;

  final double height;
  CustomText({this.text = '',
    this.fontSize = 16,
    this.color = Colors.black,
    this.alignment = Alignment.topLeft,
    this.height = 1,
    this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          height: height,
          fontSize: fontSize,
          fontWeight: fontWeight
        ),
      ),
    );
  }
}