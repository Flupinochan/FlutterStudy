import 'package:flutter/material.dart';
import 'package:first_app/dice_roller.dart';

Alignment startAlignment = Alignment.topLeft;
Alignment endAlignment = Alignment.bottomRight;

// 独自のWidget用クラス
// StatelessWidget: const 静的
// - build() を override
// StatefulWidget: var Button Click等で動的に値が変わる場合 ※なるべく動的に変わる部分だけを別ファイルに切り出して小さくする
// - createState() を override
class GradientContainer extends StatelessWidget {
  const GradientContainer({
    this.color1 = Colors.blue,
    this.color2 = Colors.green,
    super.key,
  });

  // purple名前付きConstructor、名前指定でConstructorを呼び出し可能
  const GradientContainer.purple()
    : color1 = Colors.deepPurple,
      color2 = Colors.indigo,
      super(key: null);

  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      // pubspec.yaml の assets でimageを格納したフォルダを指定し、相対パスで参照する ※最初にルート/は不要
      child: Center(
        // Column: 縦方向Flex
        child: DiceRoller(),
      ),
    );
  }
}
