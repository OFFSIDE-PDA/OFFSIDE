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

class _Root extends State<MainPage> {
  void onPressed() {
    authRepositoryProvider.signOut();
    Navigator.pop(context);
  }

  int _selectedIdx = 2;

  final List _pages = [
    KLeague(),
    Community(),
    HomePage(),
    Match(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: _pages[_selectedIdx],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIdx,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIdx = index;
            });
          },
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
          selectedItemColor: const Color.fromRGBO(14, 32, 87, 1),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedLabelStyle:
              const TextStyle(color: Color.fromRGBO(14, 32, 87, 1)),
        ));
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // currentIndex: currentIdx,
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
      selectedItemColor: const Color.fromRGBO(14, 32, 87, 1),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      selectedLabelStyle: const TextStyle(color: Color.fromRGBO(14, 32, 87, 1)),
    );
  }
}
