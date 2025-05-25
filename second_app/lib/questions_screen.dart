import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:second_app/answer_button.dart';
import 'package:second_app/data/questions.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen(this.chooseAnswer, {super.key});

  final void Function(String answer) chooseAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;

  void answerQuestion(String selectedAnswer) {
    // widget で StatefulWidget のフィールドにアクセス可能
    widget.chooseAnswer(selectedAnswer);
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Centerと同じ記法
      child: Container(
        margin: EdgeInsets.all(40), // Containerでwrapしてmarginを適用
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // 横幅いっぱいに拡張
          children: [
            Text(
              questions[currentQuestionIndex].text,
              // GoogleFontsでフォントを変えられる
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // mapは新しい配列を作成するので、...スプレッドして展開する
            ...questions[currentQuestionIndex].getShuffledAnswers().map((
              answer,
            ) {
              return AnswerButton(
                answerText: answer,
                onTap: () {
                  answerQuestion(answer);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
