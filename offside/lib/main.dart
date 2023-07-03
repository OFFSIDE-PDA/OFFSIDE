import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

import 'MainPage/main_page.dart';

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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 255)),
          useMaterial3: true,
        ),
        // home: const MainPage(title: 'Offside'),
        home: MainPage());
  }
}

class Move extends StatelessWidget {
  const Move({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("페이지 이동"),
      onPressed: () {
        Navigator.of(context).pushNamed('/mainpage');
      },
    );
  }
}
