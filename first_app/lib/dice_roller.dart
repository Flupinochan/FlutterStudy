import 'package:flutter/material.dart';
import 'dart:math';

final Random random = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

// _アンダースコアから始まるclassも必須
// _はprivateなclassを示す
class _DiceRollerState extends State<DiceRoller> {
  int diceNumber = 1;

  void rollDice() {
    // setState関数内で変数を変えると、UIが再レンダリングされる
    setState(() {
      diceNumber = random.nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 中央ぞろえ
      children: [
        Image.asset('assets/images/dice-$diceNumber.png', width: 200),
        SizedBox(height: 20), // paddingの代わりとして挿入(spacer) ※幅と高さが固定
        TextButton(
          onPressed: rollDice,
          // Text styleではなく、Button styleでtextの色を変える
          style: TextButton.styleFrom(
            // padding: const EdgeInsets.only(top: 20),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 28),
          ),
          child: Text('Roll Dice'),
        ),
      ],
    );
  }
}
