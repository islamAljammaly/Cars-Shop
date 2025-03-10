import 'package:flutter/material.dart';
import '../constant.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final Color color;

  final void Function()? onPress;

  CustomButton({
    required this.onPress,
    this.text = 'Write text ',
    this.color = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(primaryColor),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      onPressed: onPress,
      child: CustomText(
        alignment: Alignment.center,
        text: text,
        color: Colors.white,
      ),
    );
  }
}