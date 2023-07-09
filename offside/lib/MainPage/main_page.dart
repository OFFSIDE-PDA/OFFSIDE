import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Kleague/kLeague.dart';
import 'package:offside/data/repository/auth_repository.dart';

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

  final List<String> entries = <String>['A', 'B', 'C'];
  int _selectedIdx = 2;
  List _pages = [
    KLeague(),
    Container(
      child: Text("2nd"),
    ),
    HomePage(),
    Container(child: Text("3rd")),
    Container(child: Text("4th")),
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
          actions: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "KOREAN ",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Container(width: 1, height: 15, color: Colors.grey),
                    const Text(
                      " ENGLISH",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(33, 58, 135, 1))),
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              ],
            )
          ],
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
          selectedItemColor: const Color.fromRGBO(33, 58, 135, 1),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedLabelStyle:
              const TextStyle(color: Color.fromRGBO(33, 58, 135, 1)),
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => Home();
}

class Home extends State<HomePage> {
  bool flag = true;
  final List<String> k1 = <String>['k1-1', 'k1-2', 'k1-3', 'k1-4', 'k1-5'];
  final List<String> k2 = <String>['k2-1', 'k2-2', 'k2-3', 'k2-4', 'k2-5'];
  var schedule = <String>['k1-1', 'k1-2', 'k1-3', 'k1-4', 'k1-5'];
  void chooseLeague() {
    setState(() {
      flag = !flag;
      if (flag == true) {
        schedule = k1;
      } else {
        schedule = k2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const borderSide = BorderSide(
      color: Colors.grey,
      width: 2.0,
    );
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              const Text("경기 일정"),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: chooseLeague,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: flag == true
                        ? const Color.fromRGBO(33, 58, 135, 1)
                        : Colors.white,
                    side: borderSide,
                  ),
                  child: Text(
                    "K리그1",
                    style: TextStyle(
                        fontSize: 12,
                        color: flag == true ? Colors.white : Colors.grey),
                  )),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: chooseLeague,
                style: ElevatedButton.styleFrom(
                  backgroundColor: flag == true
                      ? Colors.white
                      : const Color.fromRGBO(33, 58, 135, 1),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ), // Background color
                ),
                child: Text(
                  "K리그2",
                  style: TextStyle(
                      fontSize: 12,
                      color: flag == true ? Colors.grey : Colors.white),
                ),
              )
            ],
          ),
        ),
        MatchCarousel(size: size, league: schedule),
        HotMatch(size: size),
        StadiumTour(size: size),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "경기장 주변 팬 추천 맛집 리스트",
                  style: TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 67, 67, 67)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'images/navigationbar/kLeague.png',
                    width: 100,
                    height: 100,
                  ),
                  Image.asset(
                    'images/navigationbar/kLeague.png',
                    width: 100,
                    height: 100,
                  ),
                  Image.asset(
                    'images/navigationbar/kLeague.png',
                    width: 100,
                    height: 100,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              RestaurantList()
            ],
          ),
        )
      ]),
    );
  }
}

class RestaurantList extends StatelessWidget {
  const RestaurantList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
        color: const Color.fromARGB(255, 213, 213, 213),
        borderRadius: BorderRadius.circular(5));
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
            decoration: boxDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("- 채사랑",
                    style: TextStyle(color: Color.fromARGB(255, 67, 67, 67))),
                Row(
                  children: [
                    Icon(Icons.map),
                    Text("지도보기",
                        style:
                            TextStyle(color: Color.fromARGB(255, 67, 67, 67)))
                  ],
                )
              ],
            )),
        Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
            decoration: boxDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "- 채사랑",
                  style: TextStyle(color: Color.fromARGB(255, 67, 67, 67)),
                ),
                Row(
                  children: [
                    Icon(Icons.map),
                    Text("지도보기",
                        style:
                            TextStyle(color: Color.fromARGB(255, 67, 67, 67)))
                  ],
                )
              ],
            )),
        Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
            decoration: boxDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("- 채사랑",
                    style: TextStyle(color: Color.fromARGB(255, 67, 67, 67))),
                Row(
                  children: [
                    Icon(Icons.map),
                    Text("지도보기",
                        style:
                            TextStyle(color: Color.fromARGB(255, 67, 67, 67)))
                  ],
                )
              ],
            ))
      ],
    );
  }
}

class StadiumTour extends StatelessWidget {
  const StadiumTour({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: const Color.fromRGBO(33, 58, 135, 1),
          width: size.width,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text(
              "경기장 주변 관광 일정 보러가기",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                  color: const Color.fromRGBO(33, 58, 135, 1),
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.chevron_right,
                  ),
                  onPressed: () {
                    // do something
                  }),
            ),
          ]),
        ),
      ],
    );
  }
}

class HotMatch extends StatelessWidget {
  const HotMatch({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    const textStyle =
        TextStyle(fontSize: 18, color: Color.fromARGB(255, 67, 67, 67));
    const sizedBox = SizedBox(
      width: 10,
    );
    return Column(
      children: [
        Container(
            color: const Color.fromRGBO(33, 58, 135, 1),
            width: size.width,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "금주의 HOT MATCH!",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/navigationbar/kLeague.png',
                width: 25,
                height: 25,
              ),
              sizedBox,
              Text("대구", style: textStyle),
              sizedBox,
              Text("VS", style: textStyle),
              sizedBox,
              Text("포항", style: textStyle),
              sizedBox,
              Image.asset(
                'images/navigationbar/kLeague.png',
                width: 25,
                height: 25,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MatchCarousel extends StatelessWidget {
  const MatchCarousel({
    super.key,
    required this.size,
    required this.league,
  });

  final List league;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 250.0),
      items: league.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(5, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Text('No. $i'));
          },
        );
      }).toList(),
    );
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
      selectedItemColor: const Color.fromRGBO(33, 58, 135, 1),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      selectedLabelStyle:
          const TextStyle(color: Color.fromRGBO(33, 58, 135, 1)),
    );
  }
}
