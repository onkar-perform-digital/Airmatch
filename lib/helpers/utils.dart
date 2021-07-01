import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// Text Constant function

AutoSizeText smallText(String text, var color) {
  return AutoSizeText(text,
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 14,
        color: Color(color),
      ),
      minFontSize: 10,);
}

AutoSizeText mediumText(String text, var color) {
  return AutoSizeText(text,
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w100,
        fontSize: 16,
        color: Color(color),
      ),
      minFontSize: 10,
      overflow: TextOverflow.ellipsis,
      );
}

AutoSizeText largeText(String text, var color) {
  return AutoSizeText(text,
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 18,
        color: Color(color),
      ),
      minFontSize: 10,);
}


