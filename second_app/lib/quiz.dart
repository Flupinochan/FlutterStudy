import 'package:flutter/material.dart';
import 'package:second_app/home_container.dart';
import 'package:second_app/questions_screen.dart';
import 'package:second_app/data/questions.dart';
import 'package:second_app/results_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  // 初期化処理
  // @override
  // void initState() {
  //   super.initState();
  // }

  // Widget削除時の後処理
  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // 1. 親Widgetでグローバルに使用する変数を定義
  // 2. 子Widgetに引数で渡す
  // 3. 子Widgetのプライベートクラスからは、widget.でアクセス可能
  // 子Widgetに関数を渡すことで、親Widgetの変数を変えることが可能
  String activeScreen = 'start-screen';
  List<String> selectedAnswers = []; // finalは代入で上書きできないということ、値の編集は可能

  // クイズ画面に切り替える関数
  void switchScreen() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'question-screen';
    });
  }

  // 選択した答えを追加する関数
  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    // 最後の質問の場合は、結果画面に遷移
    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = 'results-screen';
      });
    }
  }

  // build関数は、setStateが呼び出された際に再度実行される
  @override
  Widget build(BuildContext context) {
    Widget screenWidget = HomeContainer(switchScreen);
    if (activeScreen == 'question-screen') {
      screenWidget = QuestionsScreen(chooseAnswer);
    } else if (activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(selectedAnswers, switchScreen);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Quiz App")),
        body: Container(
          // 全ての画面で共通の背景色
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
