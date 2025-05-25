import 'package:flutter/material.dart';

// {}は名前付き引数を定義
// 名前付き引数の場合は、デフォルトで全て任意の引数になる
class StyledText extends StatelessWidget {
  const StyledText({
    required this.text,
    this.color = Colors.white,
    this.fontSize = 28,
    super.key,
  });

  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(context) {
    return Text(text, style: TextStyle(color: color, fontSize: fontSize));
  }
}
