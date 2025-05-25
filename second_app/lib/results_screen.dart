import 'package:flutter/material.dart';
import 'package:second_app/data/questions.dart';
import 'package:second_app/questions_summary.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(this.selectedAnswers, this.onRestartQuiz, {super.key});

  final List<String> selectedAnswers;
  final void Function() onRestartQuiz;

  // 問題番号、問題文、選択した回答、正しい回答を格納したMapを作成
  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (int i = 0; i < selectedAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0], // 0番目を正解で設定しているため
        'user_answer': selectedAnswers[i],
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestions = questions.length;
    final numCorrectQuestions =
        getSummaryData().where((data) {
          return data['user_answer'] == data['correct_answer'];
        }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '正答率: $numCorrectQuestions / $numTotalQuestions',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 30),
            QuestionsSummary(getSummaryData()),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: onRestartQuiz,
              child: Text('再挑戦', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
