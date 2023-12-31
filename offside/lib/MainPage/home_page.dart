import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/Kleague/TeamInfo.dart';
import 'package:offside/data/model/match_model.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/page_view_model.dart';
import '../Match/matchDetail.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
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
    final matchData = ref.watch(matchViewModelProvider);
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
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
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 11),
                        color: league == 1 ? Colors.white : Colors.grey,
                      ),
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
                      width: 1.0,
                    ), // Background color
                  ),
                  child: Text(
                    "K리그2",
                    style: TextStyle(
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 11),
                      color: league == 1 ? Colors.grey : Colors.white,
                    ),
                  ),
                )
              ],
            )),
        MatchCarousel(
            size: size,
            info: matchData.getWeekMatches(league),
            page: getPageNum,
            teaminfoList: teamInfoList),
        RandomMatch(
            size: size,
            info: matchData.getRandomMatch(),
            teaminfoList: teamInfoList),
        StadiumTour(
            hSizedBox: hSizedBox,
            date: matchData.getLatestDay(),
            info: matchData.getHomeTeams(),
            teaminfoList: teamInfoList)
      ]),
    );
  }
}

class StadiumTour extends StatelessWidget {
  const StadiumTour(
      {super.key,
      required this.hSizedBox,
      required this.info,
      required this.teaminfoList,
      required this.date});

  final SizedBox hSizedBox;
  final List info;
  final List<TeamInfo> teaminfoList;
  final String date;

  String convertedName(name) {
    if (name == "전남 드래곤즈") {
      return "전남";
    }

    return name;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    String convertTime(date) {
      return "${date[2]}${date[3]}월 ${date[4]}${date[5]}일";
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              "${convertTime(date)} 홈경기 관광 정보",
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 11),
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 100, 100, 100)),
            ),
          ),
          hSizedBox,
          Container(
            height: info.length >= 9 ? size.height * 0.32 : size.height * 0.22,
            //여기 Media로 화면 크기 받아서 height 나눠주기 -------------------------------------- 민수
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
                physics: new NeverScrollableScrollPhysics(),
                itemCount: info.length, //item 개수 -> 20개까지만
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
                                builder: (context) => TeamInfoPage(
                                    team: teaminfoList[info[index]])));
                      },
                      elevation: 7,
                      highlightElevation: 15,
                      backgroundColor: Color.fromARGB(255, 241, 241, 241),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.1,
                            color: Color.fromARGB(255, 241, 241, 241),
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child: Image.network(
                                  teaminfoList[info[index]].logoImg),
                            ),
                            Text(
                              convertedName(
                                  teaminfoList[info[index]].middleName),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 10),
                                  fontWeight: FontWeight.w500),
                            )
                          ]));
                }),
          ),
          hSizedBox,
        ]));
  }
}

class RandomMatch extends ConsumerWidget {
  const RandomMatch(
      {super.key,
      required this.size,
      required this.info,
      required this.teaminfoList});

  final Size size;
  final MatchModel info;
  final List<TeamInfo> teaminfoList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textStyle = TextStyle(
        fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 13),
        color: const Color.fromRGBO(18, 32, 84, 1),
        fontWeight: FontWeight.w600);
    const sizedBox = SizedBox(
      width: 10,
    );
    return Column(children: [
      Container(
          color: const Color.fromRGBO(18, 32, 84, 1),
          width: size.width,
          padding: const EdgeInsets.all(10),
          child: Text(
            '이 MATCH 어때?',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 12)),
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
                    child: Image.network(teaminfoList[info.team1!].logoImg)),
                sizedBox,
                Text(teaminfoList[info.team1!].fullName, style: textStyle),
                sizedBox,
                Text("VS", style: textStyle),
                sizedBox,
                Text(teaminfoList[info.team2!].fullName, style: textStyle),
                sizedBox,
                SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.network(teaminfoList[info.team2!].logoImg))
              ])),
      Row(children: [
        Container(
            color: const Color.fromRGBO(18, 32, 84, 1),
            width: size.width,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                "이 MATCH 자세히 보기",
                style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 11),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
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
                        ref.read(counterPageProvider.notifier).update((state) =>
                            [
                              3,
                              "${info.league!.toString()}_${info.id!.toString()}"
                            ]);
                      }))
            ]))
      ])
    ]);
  }
}

class MatchCarousel extends StatelessWidget {
  const MatchCarousel(
      {super.key,
      required this.size,
      required this.info,
      required this.page,
      required this.teaminfoList});
  final Size size;
  final List<dynamic> info;
  final Function page;
  final List<TeamInfo> teaminfoList;

  @override
  Widget build(BuildContext context) {
    return info.isNotEmpty
        ? CarouselSlider.builder(
            itemCount: info.length,
            itemBuilder: ((BuildContext context, int index, int realIndex) {
              return MatchBox(
                  size: size, match: info[index], teaminfoList: teaminfoList);
            }),
            options: CarouselOptions(
                height: size.height * 0.295,
                onPageChanged: (index, reason) {
                  page(index);
                }))
        : Container(
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
            margin: const EdgeInsets.fromLTRB(40, 30, 40, 30),
            width: size.width,
            height: size.height * 0.22,
            child: const Center(child: Text('경기가 없습니다')));
  }
}

class MatchBox extends StatelessWidget {
  const MatchBox(
      {super.key,
      required this.size,
      required this.match,
      required this.teaminfoList});

  final Size size;
  final List<dynamic> match;
  final List<TeamInfo> teaminfoList;

  String getDate(data) {
    return "${data[0]}${data[1]}년 ${data[2]}${data[3]}월 ${data[4]}${data[5]}일";
  }

  String convertTime(date) {
    var tmp = int.parse(date[0] + date[1]);
    var returnString = '';
    if (tmp < 12) {
      returnString = (tmp + 12).toString();
    }

    return "$returnString:${date[2]}${date[3]}";
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
        child: ListView.builder(
            shrinkWrap: true, // ListView가 자식 위젯의 크기에 맞게 축소될 수 있도록 설정
            physics:
                const ClampingScrollPhysics(), // 스크롤 물리학을 ClampingScrollPhysics로 설정하여 스크롤 효과를 줍니다.
            itemCount: 1,
            itemBuilder: (context, index) {
              return (Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getDate(match.first.data),
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 11)),
                    ),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('H',
                              style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 11),
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600)),
                          Text('A',
                              style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 11),
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600)),
                        ]),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: match.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      convertTime(match[index].time),
                                      style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(
                                                  context, 10)),
                                    ),
                                    SizedBox(
                                        width: size.width * 0.08,
                                        height: size.width * 0.08,
                                        child: Image.network(
                                            teaminfoList[match[index].team1]
                                                .logoImg)),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            teaminfoList[match[index].team1]
                                                .name,
                                            style: TextStyle(
                                                color: Color(teaminfoList[
                                                        match[index].team1]
                                                    .color[0]),
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 11)),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          Text(
                                            ' vs ',
                                            style: TextStyle(
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 12),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          Text(
                                            teaminfoList[match[index].team2]
                                                .name,
                                            style: TextStyle(
                                                color: Color(teaminfoList[
                                                        match[index].team2]
                                                    .color[0]),
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 11)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ]),
                                    SizedBox(
                                        width: size.width * 0.08,
                                        height: size.width * 0.08,
                                        child: Image.network(
                                            teaminfoList[match[index].team2]
                                                .logoImg)),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MatchDetail(
                                                        date: getDate(
                                                            match[index].data),
                                                        time:
                                                            match[index].time!,
                                                        team1:
                                                            match[index].team1!,
                                                        team2:
                                                            match[index].team2!,
                                                        score1:
                                                            match[index].score1,
                                                        score2:
                                                            match[index].score2,
                                                        matchId:
                                                            match[index].id,
                                                        league:
                                                            match[index].league,
                                                      )));
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    33, 58, 135, 1),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: const Icon(
                                                CupertinoIcons.paperplane,
                                                color: Colors.white,
                                                size: 15)))
                                  ]));
                        })
                  ]));
            }));
  }
}
