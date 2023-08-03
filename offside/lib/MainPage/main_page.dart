import 'package:flutter/material.dart';
import 'package:offside/MainPage/home_page.dart';
import 'package:offside/Match/match.dart';
import '../Kleague/kLeague.dart';
import 'package:offside/data/repository/auth_repository.dart';
import '../community/Community.dart';
import '../MyPage/mypage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _Root();
}

class _Root extends State<MainPage> with SingleTickerProviderStateMixin {
  void onPressed() {
    authRepositoryProvider.signOut();
    Navigator.pop(context);
  }

  int _selectedIdx = 2;

  final List _pages = [
    const KLeague(),
    const Community(),
    const HomePage(),
    Match(),
    const MyPage(),
  ];

  late final TabController controller;

  late List<GlobalKey<NavigatorState>> _navigatorKeyList;

  @override
  void initState() {
    controller = TabController(length: 5, vsync: this, initialIndex: 2);
    super.initState();
    _navigatorKeyList =
        List.generate(_pages.length, (index) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_selectedIdx]
            .currentState!
            .maybePop());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leadingWidth: 0,
          titleSpacing: 0,
          title: Image.asset(
            "/images/mainpage/logo.png",
            width: 120,
            height: double.maxFinite,
          ),
          shape: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIdx,
          children: _pages.map((page) {
            int idx = _pages.indexOf(page);
            return Navigator(
              key: _navigatorKeyList[idx],
              onGenerateRoute: (_) {
                return MaterialPageRoute(builder: (context) => page);
              },
            );
          }).toList(),
          // child: Navigator(
          //   key: _navigatorKeyList[_selectedIdx],
          //   onGenerateRoute: (_) {
          //     return MaterialPageRoute(
          //         builder: (context) => _pages[_selectedIdx]);
          //   },
          // ),
        ),
        bottomNavigationBar: TabBar(
          controller: controller,
          indicatorColor: const Color.fromRGBO(14, 32, 87, 1),
          labelColor: const Color.fromRGBO(14, 32, 87, 1),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 10),
          labelPadding: EdgeInsets.zero,
          onTap: (index) {
            setState(() {
              _selectedIdx = index;
            });
          },
          tabs: [
            Tab(
              text: 'K리그',
              icon: Image.asset(
                'images/navigationbar/kLeague.png',
                width: 25,
                height: 25,
                color: controller.index == 0
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
            Tab(
              text: '커뮤니티',
              icon: Image.asset(
                'images/navigationbar/team_community.png',
                width: 25,
                height: 25,
                color: controller.index == 1
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
            Tab(
              text: '홈',
              icon: Image.asset(
                'images/navigationbar/home.png',
                width: 25,
                height: 25,
                color: controller.index == 2
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
            Tab(
              text: '경기일정',
              icon: Image.asset(
                'images/navigationbar/match_schedule.png',
                width: 25,
                height: 25,
                color: controller.index == 3
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
            Tab(
              text: '마이페이지',
              icon: Image.asset(
                'images/navigationbar/mypage.png',
                width: 25,
                height: 25,
                color: controller.index == 4
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
