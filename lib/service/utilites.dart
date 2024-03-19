import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/constant/style_guide.dart';

class Utilites {
  static String randomID() {
    Random random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static String randomPassword(
    bool hasLower,
    bool hasUpper,
    bool hasSymbol,
    bool hasNumber,
    String customChars,
    int length,
  ) {
    StringBuffer buffer = StringBuffer();
    StringBuffer resultBuffer = StringBuffer();

    if (hasLower) {
      buffer.write("abcdefghijklmnopqrstuvwxyz");
    }
    if (hasUpper) {
      buffer.write("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (hasSymbol) {
      buffer.write("!@#%^&*()_+}{|?<>}");
    }
    if (hasNumber) {
      buffer.write("1234567890");
    }
    Random random = Random();
    for (int i = 0; i < length - customChars.length; i++) {
      resultBuffer
          .write(buffer.toString()[random.nextInt(buffer.toString().length)]);
    }
    int index = random.nextInt(resultBuffer.length - 1);
    String result = resultBuffer.toString();
    return "${result.substring(0, index)}$customChars${result.substring(index)}";
  }

  static void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: AppColor.black,
      duration: const Duration(seconds: 1),
    ));
  }
}
