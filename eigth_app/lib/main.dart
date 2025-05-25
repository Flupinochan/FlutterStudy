import 'package:eigth_app/screens/auth.dart';
import 'package:eigth_app/screens/chat.dart';
import 'package:eigth_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177),
        ),
      ),
      // FutureBuilderに似ている
      // Streamデータ受信時に再レンダリング
      // Future: 単発 Stream: 複数回(Websocket)
      home: StreamBuilder(
        // サインインステータス変更時にトリガー
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          // ロード中の画面
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          // サインイン済みの場合はデータがある
          // Firebase SDKはサインイン状態を自動管理してくれる
          if (snapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
