import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/Kleague/TeamInfo.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:offside/data/view/match_view_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends ConsumerState {
  int league = 1;
  final List<String> k1 = <String>['k1-1', 'k1-2', 'k1-3', 'k1-4', 'k1-5'];
  final List<String> k2 = <String>['k2-1', 'k2-2', 'k2-3', 'k2-4', 'k2-5'];
  List<dynamic> randomMatch = [
    ['', '']
  ];

  late List homeTeams;
  List<dynamic> matches = [];
  var page = 1;

  void chooseLeague() {
    setState(() {
      if (league == 1) {
        league = 2;
      } else {
        league = 1;
      }
    });
  }

  int pageNum = 0;
  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var matchData = ref.watch(matchViewModelProvider);
    var weekMatch = matchData.getWeekMatches(league);
    var randomMatch = matchData.getRandomMatch();
    var homeTeams = matchData.getHomeTeams();
    var isNull = matchData.isNull();
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
                  backgroundColor: league == 1
                      ? const Color.fromRGBO(14, 32, 87, 1)
                      : Colors.white,
                  side: borderSide,
                ),
                child: Text(
                  "K리그1",
                  style: TextStyle(
                      fontSize: 12,
                      color: league == 1 ? Colors.white : Colors.grey,
                      fontFamily: 'NanumSquare'),
                )),
            wSizedBox,
            ElevatedButton(
              onPressed: chooseLeague,
              style: ElevatedButton.styleFrom(
                backgroundColor: league == 1
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
                    color: league == 1 ? Colors.grey : Colors.white,
                    fontFamily: 'NanumSquare'),
              ),
            )
          ],
        ),
      ),
      isNull == true
          ? Column(
              children: [
                MatchCarousel(size: size, info: weekMatch, page: getPageNum),
                RandomMatch(size: size, info: randomMatch),
                StadiumTour(hSizedBox: hSizedBox, info: homeTeams)
              ],
            )
          : Container(
              alignment: const Alignment(0.0, 0.0),
              height: size.height - 100,
              child: const CircularProgressIndicator())
    ]));
  }
}

class StadiumTour extends StatelessWidget {
  const StadiumTour({
    super.key,
    required this.hSizedBox,
    required this.info,
  });

  final SizedBox hSizedBox;
  final List info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: const Text(
              "경기장 주변 추천 맛집 리스트",
              style: TextStyle(
                  fontSize: 17, color: Color.fromARGB(255, 67, 67, 67)),
            ),
          ),
          hSizedBox,
          Container(
            height: info.length / 4 * 100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              itemCount: info.length, //item 개수
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
                childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                mainAxisSpacing: 20, //수평 Padding
                crossAxisSpacing: 20, //수직 Padding
              ),
              itemBuilder: (BuildContext context, int index) {
                return FloatingActionButton(
                  heroTag: index,
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeamInfo(team: info[index])));
                  },
                  elevation: 10,
                  highlightElevation: 20,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color.fromRGBO(33, 58, 135, 1),
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(teamTransfer[info[index]]['img']),
                      ),
                      Text(teamTransfer[info[index]]['name'])
                    ],
                  ),
                );
              },
            ),
          ),
          hSizedBox,
        ],
      ),
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
  final List<dynamic> info;

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
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(teamTransfer[info[0]]['img'])),
              sizedBox,
              Text(info[0], style: textStyle),
              sizedBox,
              const Text("VS", style: textStyle),
              sizedBox,
              Text(info[1], style: textStyle),
              sizedBox,
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(teamTransfer[info[1]]['img']))
            ],
          ),
        ),
        Row(
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
        )
      ],
    );
  }
}

class MatchCarousel extends StatelessWidget {
  const MatchCarousel({
    super.key,
    required this.size,
    required this.info,
    required this.page,
  });
  final Size size;
  final List<dynamic> info;
  final Function page;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: info.length,
      itemBuilder: ((BuildContext context, int index, int realIndex) {
        return MatchBox(size: size, match: info[index]);
      }),
      options: CarouselOptions(
          height: 280.0,
          onPageChanged: (index, reason) {
            page(index);
          }),
    );
  }
}

class MatchBox extends StatelessWidget {
  const MatchBox({
    super.key,
    required this.size,
    required this.match,
  });

  final Size size;
  final List<dynamic> match;

  String getDate(data) {
    return "${data[0]}${data[1]}.${data[2]}${data[3]}.${data[4]}${data[5]}";
  }

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
                            child: Image.asset(
                                teamTransfer[match[index].team1]['img'])),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                teamTransfer[match[index].team1]['name'],
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                ' vs ',
                                style: TextStyle(fontSize: 13),
                              ),
                              Text(
                                teamTransfer[match[index].team2]['name'],
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                        SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: Image.asset(
                                teamTransfer[match[index].team2]['img'])),
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
