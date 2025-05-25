import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';  // IOS用のUIにしたい場合
// if (Platform.isIOS) でチェック可能

// import 'package:flutter/services.dart'; // 画面の向きを設定するライブラリ

import 'package:third_app/expenses.dart';

// グローバル変数の命名規則は、「k」から始める
// カラーパレットを自動生成
var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 5, 99, 125),
);

Future<void> main() async {
  // デバイスの向きを固定
  // WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // デフォルトでuseMaterial3というバージョン3のテーマが適用されている
  runApp(
    MaterialApp(
      home: Expenses(),
      // themeMode: ThemeMode.dark,
      // dark theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      // themeはホワイトテーマ
      theme: ThemeData(
        colorScheme: kColorScheme,
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(fontWeight: FontWeight.normal),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: CardTheme(
          color: kColorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
      ),
    ),
  );
}
