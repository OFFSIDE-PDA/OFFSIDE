import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:offside/MainPage/main_page.dart';
import 'package:offside/firebase_options.dart';
import 'package:offside/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(
    nativeAppKey: '3b301db0810e0f8f0caa883c9c7b43ba',
    javaScriptAppKey: 'a8bd91fccbb230b5011148456b3cd404',
  );

  runApp(ProviderScope(
    child: Offside(),
  ));
}

class Offside extends StatelessWidget {
  const Offside({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Offside',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 255)),
          useMaterial3: true,
        ),
        home: LoginPage());
  }
}
