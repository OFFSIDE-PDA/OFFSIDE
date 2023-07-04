import 'package:flutter/material.dart';
import 'package:offside/login/login.dart';

void main() {
  runApp(const Offside());
}

// final routes = {
//   '/mainpage': (BuildContext context) => const MainPage(
//         title: '메인페이지',
//       )
// };

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
        // home: const MainPage(title: 'Offside'),
        home: LoginPage());
  }
}
