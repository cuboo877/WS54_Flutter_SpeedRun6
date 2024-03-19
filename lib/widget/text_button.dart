import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/constant/style_guide.dart';

Widget appTextButton(
    String text, Color backgroundColor, int textSize, onPressed) {
  return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: AppColor.white, fontSize: textSize.toDouble()),
      ));
}
