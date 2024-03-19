import 'package:flutter/cupertino.dart';

Widget customText(String text, int size, Color color, bool isBold) {
  return Text(
    text,
    style: TextStyle(
        fontSize: size.toDouble(),
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
  );
}
