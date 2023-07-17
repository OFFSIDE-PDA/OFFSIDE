import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:offside/MainPage/main_page.dart';
import 'package:offside/firebase_options.dart';
import 'package:offside/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Offside());
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
        home: MainPage());
  }
}
