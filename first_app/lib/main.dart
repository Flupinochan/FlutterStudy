// Flutterフレームワーク(Text, Buttonなどのウィジェットを含む)をimport
import 'package:flutter/material.dart';
// project名/ファイル名 でimport
import 'package:first_app/gradient_container.dart';

// mainは、Dartエントリーポイント
void main() {
  // runApp は、Flutterエントリーポイント
  // MaterialApp は、トップレベルのAndroid向けウィジェットで、テーマや初期設定を行う
  // CupertinoApp は、iOS向けのウィジェットが利用可能
  // home: は、起動時に表示するホーム画面
  runApp(MaterialApp(home: Scaffold(body: GradientContainer.purple())));
}
