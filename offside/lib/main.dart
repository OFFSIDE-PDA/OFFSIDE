import 'package:flutter/material.dart';
import 'MainPage/main_page.dart';
import 'Kleague/kLeague.dart';

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


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final _pages = [
    KLeague(),
  ];

  late List<GlobalKey<NavigatorState>> _navigatorKeyList;
  int flagCnt = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigatorKeyList =
        List.generate(_pages.length, (index) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Scaffold(
          body: SizedBox(child: KLeague()),
          bottomNavigationBar: BottomNavigationBar(
            //currentIndex: currentIdx,
            type: BottomNavigationBarType.fixed,
            // onTap: (index) {
            //   setState(() {
            //     currentIdx = index;
            //   });
            // },
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/navigationbar/kLeague.png',
                    width: 25,
                    height: 25,
                  ),
                  label: 'K리그',
                  activeIcon: Image.asset(
                    'images/navigationbar/kLeague.png',
                    width: 25,
                    height: 25,
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/navigationbar/team_community.png',
                    width: 25,
                    height: 25,
                  ),
                  label: '팀 커뮤니티',
                  activeIcon: Image.asset(
                    'images/navigationbar/team_community.png',
                    width: 25,
                    height: 25,
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/navigationbar/home.png',
                    width: 25,
                    height: 25,
                  ),
                  label: '홈',
                  activeIcon: Image.asset(
                    'images/navigationbar/home.png',
                    width: 25,
                    height: 25,
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/navigationbar/match_schedule.png',
                    width: 25,
                    height: 25,
                  ),
                  label: '경기 일정',
                  activeIcon: Image.asset(
                    'images/navigationbar/match_schedule.png',
                    width: 25,
                    height: 25,
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/navigationbar/mypage.png',
                    width: 25,
                    height: 25,
                  ),
                  label: '마이페이지',
                  activeIcon: Image.asset(
                    'images/navigationbar/mypage.png',
                    width: 25,
                    height: 25,
                  )),
            ],
            unselectedItemColor: Colors.black,
            selectedItemColor: const Color.fromRGBO(33, 58, 135, 1),
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            selectedLabelStyle:
                const TextStyle(color: Color.fromRGBO(33, 58, 135, 1)),
          ),
        ),
      ),
    );
  }
}
