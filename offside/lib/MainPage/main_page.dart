import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/MainPage/home_page.dart';
import 'package:offside/Match/match.dart';
import 'package:offside/TourSchedule/tourSchedule.dart';
import '../Kleague/kLeague.dart';
import '../MyPage/mypage.dart';
import 'package:offside/page_view_model.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _Root createState() => _Root();
}

class _Root extends ConsumerState with SingleTickerProviderStateMixin {
  final _navigatorKeyList =
      List.generate(5, (index) => GlobalKey<NavigatorState>());
  late TabController _tabController;

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
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = ref.watch(counterPageProvider);
    return WillPopScope(
        onWillPop: () async {
          return !(await _navigatorKeyList[_tabController.index]
              .currentState!
              .maybePop());
        },
        child: DefaultTabController(
          initialIndex: 2,
          length: 5,
          child: Scaffold(
            appBar: _tabController.index == 2
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: AppBar(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      leadingWidth: 0,
                      titleSpacing: 0,
                      title: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(
                            "assets/images/mainpage/logo.png",
                            height: 35,
                          )),
                      shape: const Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                  )
                : null,
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
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
            bottomNavigationBar: SizedBox(
              height: 50,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color.fromRGBO(14, 32, 87, 1),
                labelColor: const Color.fromRGBO(14, 32, 87, 1),
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontSize: 10, letterSpacing: 1.5),
                labelPadding: EdgeInsets.zero,
                automaticIndicatorColorAdjustment: true,
                onTap: (index) {
                  // _tabController.index = 1;
                  ref
                      .read(counterPageProvider.notifier)
                      .update((state) => index);
                },
                tabs: [
                  Tab(
                    text: 'K리그',
                    icon: Image.asset(
                      'assets/images/navigationbar/kLeague.png',
                      width: 20,
                      height: 20,
                      color: _tabController.index == 0
                          ? const Color.fromRGBO(14, 32, 87, 1)
                          : Colors.grey,
                    ),
                    iconMargin: const EdgeInsets.only(bottom: 5.0),
                  ),
                  Tab(
                    text: '여행 일정',
                    icon: Image.asset(
                      'assets/images/navigationbar/tour_schedule.png',
                      width: 20,
                      height: 20,
                      color: _tabController.index == 1
                          ? const Color.fromRGBO(14, 32, 87, 1)
                          : Colors.grey,
                    ),
                    iconMargin: const EdgeInsets.only(bottom: 5.0),
                  ),
                  Tab(
                    text: '홈',
                    icon: Image.asset(
                      'assets/images/navigationbar/home.png',
                      width: 20,
                      height: 20,
                      color: _tabController.index == 2
                          ? const Color.fromRGBO(14, 32, 87, 1)
                          : Colors.grey,
                    ),
                    iconMargin: const EdgeInsets.only(bottom: 5.0),
                  ),
                  Tab(
                    text: '경기일정',
                    icon: Image.asset(
                      'assets/images/navigationbar/match_schedule.png',
                      width: 20,
                      height: 20,
                      color: _tabController.index == 3
                          ? const Color.fromRGBO(14, 32, 87, 1)
                          : Colors.grey,
                    ),
                    iconMargin: const EdgeInsets.only(bottom: 5.0),
                  ),
                  Tab(
                    text: '마이페이지',
                    icon: Image.asset(
                      'assets/images/navigationbar/mypage.png',
                      width: 20,
                      height: 20,
                      color: _tabController.index == 4
                          ? const Color.fromRGBO(14, 32, 87, 1)
                          : Colors.grey,
                    ),
                    iconMargin: const EdgeInsets.only(bottom: 5.0),
                  ),
                ],
              ),
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
