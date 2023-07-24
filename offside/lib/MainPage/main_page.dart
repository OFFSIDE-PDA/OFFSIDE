import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:offside/Schedule/schedule.dart';
import '../Kleague/kLeague.dart';
import 'package:offside/data/repository/auth_repository.dart';
import '../community/Community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../MyPage/mypage.dart';
import 'package:intl/intl.dart';

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
  List _pages = [
    KLeague(),
    CommunityPage(),
    HomePage(),
    Schedule(),
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

class MatchData {
  String? data;
  String? score2;
  String? team1;
  String? team2;
  String? location;
  String? time;
  String? score1;
  MatchData(this.data, this.score2, this.team1, this.team2, this.location,
      this.time, this.score1);
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
  var schedule;
  late Future<List<List>> kLeagueOne;
  late Future<List<List>> kLeagueTwo;
  final firestore = FirebaseFirestore.instance;
  List<dynamic> randomMatch = [
    ['', '']
  ];

  late List homeTeams;
  List<dynamic> matches = [];
  var page = 1;

  void chooseLeague() {
    setState(() {
      flag = !flag;
      if (flag == true) {
        schedule = kLeagueOne;
      } else {
        schedule = kLeagueTwo;
      }
    });
  }

  List getHomeTeams(List matches) {
    List<dynamic> tmp = [];
    for (var element in matches) {
      tmp.add(element[0]);
    }
    return tmp;
  }

  Future<List<List>> getMatchData(int league, int today) async {
    final firestore = FirebaseFirestore.instance;
    var result = (league == 1)
        ? await firestore.collection('match').doc('kLeague1').get()
        : await firestore.collection('match').doc('kLeague2').get();
    var data = result.data()?['match'];
    List<List> kLeague = [];

    var lastDay = "";

    for (var i = 0; i < data.length; i++) {
      if (kLeague.length == 5) {
        break;
      }
      var e = data[i];
      lastDay = e['data'];
      if (today > int.parse(lastDay)) {
        continue;
      }
      if (kLeague.isEmpty) {
        kLeague.add([
          MatchData(e['data'], e['score2'], e['team1'], e['team2'],
              e['location'], e['time'], e['score1'])
        ]);
        lastDay = e['data'];
      } else {
        if (kLeague.last[0].data == lastDay) {
          kLeague.last.add(MatchData(e['data'], e['score2'], e['team1'],
              e['team2'], e['location'], e['time'], e['score1']));
        } else {
          kLeague.add([
            MatchData(e['data'], e['score2'], e['team1'], e['team2'],
                e['location'], e['time'], e['score1'])
          ]);
        }
      }
      matches.add([e['team1'], e['team2'], kLeague.length]);
    }
    if (league == 2) {
      setState(() {
        randomMatch.clear();
        randomMatch.add(matches[today % matches.length]);
      });
    }
    return kLeague;
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyMMdd');
    var strToday = formatter.format(now);
    kLeagueOne = getMatchData(1, int.parse(strToday));
    kLeagueTwo = getMatchData(2, int.parse(strToday));
  }

  int pageNum = 0;

  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  int teamIndex = 0; // 경기장 주변 팬 추천 맛집 리스트용

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const borderSide = BorderSide(
      color: Colors.grey,
      width: 2.0,
    );
    const hSizedBox = SizedBox(
      height: 10,
    );
    const wSizedBox = SizedBox(
      width: 10,
    );
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              const Text(
                "경기 일정",
                style: TextStyle(fontFamily: 'NanumSquare'),
              ),
              wSizedBox,
              ElevatedButton(
                  onPressed: chooseLeague,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: flag == true
                        ? const Color.fromRGBO(14, 32, 87, 1)
                        : Colors.white,
                    side: borderSide,
                  ),
                  child: Text(
                    "K리그1",
                    style: TextStyle(
                        fontSize: 12,
                        color: flag == true ? Colors.white : Colors.grey,
                        fontFamily: 'NanumSquare'),
                  )),
              wSizedBox,
              ElevatedButton(
                onPressed: chooseLeague,
                style: ElevatedButton.styleFrom(
                  backgroundColor: flag == true
                      ? Colors.white
                      : const Color.fromRGBO(14, 32, 87, 1),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ), // Background color
                ),
                child: Text(
                  "K리그2",
                  style: TextStyle(
                      fontSize: 12,
                      color: flag == true ? Colors.grey : Colors.white,
                      fontFamily: 'NanumSquare'),
                ),
              )
            ],
          ),
        ),
        MatchCarousel(
            size: size,
            league: flag == true ? kLeagueOne : kLeagueTwo,
            page: getPageNum),
        RandomMatch(size: size, info: randomMatch),
        StadiumTour(size: size, info: randomMatch),
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
              hSizedBox,
              SizedBox(
                  height: 120.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 120,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 67, 67, 67),
                              width: 3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(1),
                          //     spreadRadius: 5,
                          //     blurRadius: 7,
                          //     offset: const Offset(
                          //         3, 3), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              teamIndex = index;
                              //클릭한 팀의 인덱스
                            });
                          },
                          child: CircleAvatar(
                            radius: 60,
                            child: teamImg[matches[index][0]],
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                    },
                  )),
              hSizedBox,
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
    required this.info,
  });

  final Size size;
  final info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: const Color.fromRGBO(14, 32, 87, 1),
          width: size.width,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text(
              "경기장 주변 관광 일정 보러가기",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumSquare'),
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
                  color: const Color.fromRGBO(14, 32, 87, 1),
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

class RandomMatch extends StatelessWidget {
  const RandomMatch({
    super.key,
    required this.size,
    required this.info,
  });

  final Size size;
  final info;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 67, 67, 67),
        fontFamily: 'NanumSquare',
        fontWeight: FontWeight.w600);
    const sizedBox = SizedBox(
      width: 10,
    );
    return Column(
      children: [
        Container(
            color: const Color.fromRGBO(14, 32, 87, 1),
            width: size.width,
            padding: const EdgeInsets.all(10),
            child: const Text(
              '이 MATCH 어때?',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30, height: 30, child: teamImg[info[0][0]]),
              sizedBox,
              Text(info[0][0], style: textStyle),
              sizedBox,
              const Text("VS", style: textStyle),
              sizedBox,
              Text(info[0][1], style: textStyle),
              sizedBox,
              SizedBox(width: 30, height: 30, child: teamImg[info[0][1]])
            ],
          ),
        )
      ],
    );
  }
}

class MatchCarousel extends StatefulWidget {
  const MatchCarousel(
      {super.key,
      required this.size,
      required this.league,
      required this.page});

  final Size size;
  final league;
  final Function(int) page;

  @override
  State<MatchCarousel> createState() => _MatchCarousel();
}

class _MatchCarousel extends State<MatchCarousel> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List>>(
        future: widget.league,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<List> matches = snapshot.data!;
            return CarouselSlider.builder(
              itemCount: matches.length,
              itemBuilder: ((BuildContext context, int index, int realIndex) {
                return MatchBox(size: widget.size, match: matches[index]);
              }),
              options: CarouselOptions(
                  height: 280.0,
                  onPageChanged: (index, reason) {
                    widget.page(index);
                  }),
            );
          } else if (snapshot.hasError) {
            return Text('error');
          }
          return Container(
            width: widget.size.width,
            height: 280,
            margin: const EdgeInsets.fromLTRB(40, 15, 40, 15),
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
          );
        }));
  }
}

class MatchBox extends StatelessWidget {
  const MatchBox({
    super.key,
    required this.size,
    required this.match,
  });

  final Size size;
  final match;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            '[${getDate(match.first.data)}]',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 5),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('H', style: TextStyle(fontSize: 13, color: Colors.blue)),
                Text('A', style: TextStyle(fontSize: 13, color: Colors.red)),
              ]),
          ListView.builder(
              shrinkWrap: true,
              itemCount: match.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${match[index].time}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: teamImg[match[index].team1]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                transferName[match[index].team1]!,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                ' vs ',
                                style: TextStyle(fontSize: 13),
                              ),
                              Text(
                                transferName[match[index].team2]!,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                        SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: teamImg[match[index].team2]),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(33, 58, 135, 1),
                                borderRadius: BorderRadius.circular(15)),
                            child: const Text(
                              "상세정보",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ));
              }),
        ]));
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
