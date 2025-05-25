import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer(this.switchScreen, {super.key});

  final void Function() switchScreen;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 画像を透過させる方法
          // 1. Opacity Widgetでwrapする ※Opacityの利用は避けるべき
          // 2. Image の Color で Alpha を設定
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 300,
            color: const Color.fromARGB(218, 255, 255, 255), // Alphaで透過させる
          ),
          SizedBox(height: 50),
          Text(
            "Learn Flutter the fun way!",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          SizedBox(height: 30),
          // Icon付きButton
          ElevatedButton.icon(
            icon: Icon(Icons.start),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
            ),
            onPressed: switchScreen,
            label: Text('Start Quiz'),
          ),
        ],
      ),
    );
  }
}
