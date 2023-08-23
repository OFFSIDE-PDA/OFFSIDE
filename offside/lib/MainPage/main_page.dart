import 'package:flutter/material.dart';
import 'package:offside/MainPage/home_page.dart';
import 'package:offside/Match/match.dart';
import 'package:offside/TourSchedule/tourSchedule.dart';
import '../Kleague/kLeague.dart';
import 'package:offside/data/repository/auth_repository.dart';
import '../community/community.dart';
import '../MyPage/mypage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _Root();
}

class _Root extends State<MainPage> with SingleTickerProviderStateMixin {
  final _navigatorKeyList =
      List.generate(5, (index) => GlobalKey<NavigatorState>());
  int _currentIndex = 2;

  void onPressed() {
    authRepositoryProvider.signOut();
    Navigator.pop(context);
  }

  final List _pages = [
    const KLeague(),
    const TourSchedule(),
    const HomePage(),
    const Match(),
    const MyPage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return !(await _navigatorKeyList[_currentIndex]
              .currentState!
              .maybePop());
        },
        child: DefaultTabController(
          initialIndex: 2,
          length: 5,
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
            body: TabBarView(
              children: _pages.map(
                (page) {
                  int index = _pages.indexOf(page);
                  return CustomNavigator(
                    page: page,
                    navigatorKey: _navigatorKeyList[index],
                  );
                },
              ).toList(),
            ),
            bottomNavigationBar: TabBar(
              indicatorColor: const Color.fromRGBO(14, 32, 87, 1),
              labelColor: const Color.fromRGBO(14, 32, 87, 1),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontSize: 10),
              labelPadding: EdgeInsets.zero,
              automaticIndicatorColorAdjustment: true,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: [
                Tab(
                  text: 'K리그',
                  icon: Image.asset(
                    'images/navigationbar/kLeague.png',
                    width: 25,
                    height: 25,
                    color: _currentIndex == 0
                        ? const Color.fromRGBO(14, 32, 87, 1)
                        : Colors.grey,
                  ),
                ),
                Tab(
                  text: '여행 일정',
                  icon: Image.asset(
                    'images/navigationbar/tour_schedule.png',
                    width: 25,
                    height: 25,
                    color: _currentIndex == 1
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
                    color: _currentIndex == 2
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
                    color: _currentIndex == 3
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
                    color: _currentIndex == 4
                        ? const Color.fromRGBO(14, 32, 87, 1)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class CustomNavigator extends StatefulWidget {
  final Widget page;
  final Key navigatorKey;
  const CustomNavigator(
      {Key? key, required this.page, required this.navigatorKey})
      : super(key: key);

  @override
  _CustomNavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends State<CustomNavigator>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (context) => widget.page),
    );
  }
}
