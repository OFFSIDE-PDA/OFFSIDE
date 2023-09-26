import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/Match/matchDetail.dart';
import 'package:offside/MyPage/myteam.dart';
import 'package:offside/data/model/match_model.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:intl/intl.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:flutter/cupertino.dart';

class Match extends ConsumerStatefulWidget {
  const Match({super.key});

  @override
  _Match createState() => _Match();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class _Match extends ConsumerState {
  List<String> league = ["K리그1", "K리그2"];
  String selectedLeague = 'K리그1';
  int selectedTeam = 1;
  bool filtering = false;
  String today = "";
  int scrollIdx = 0;
  final ScrollController _scrollController = ScrollController();

  getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyMMdd');
    formatter.format(now);
    return formatter.format(now);
  }

  @override
  void initState() {
    super.initState();
    today = getToday();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const borderSide = BorderSide(
      color: Color.fromARGB(255, 67, 67, 67),
      width: 1.0,
    );
    const iconStyle =
        Icon(Icons.expand_more, color: Color.fromARGB(255, 67, 67, 67));
    var textStyle = TextStyle(
        fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 12),
        color: const Color.fromARGB(255, 67, 67, 67));
    var elevatedStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        backgroundColor: Colors.white,
        side: borderSide);
    final matchData = ref.read(matchViewModelProvider);
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    final k1 = teamInfoList.where((element) => element.league == 1).toList();
    final k2 = teamInfoList.where((element) => element.league == 2).toList();

    final filteredTeam = matchData.getFilteredTeams(
        selectedLeague == 'K리그1' ? 1 : 2, selectedTeam);
    var leagueLen =
        matchData.getLeagueLength('all', selectedLeague == 'K리그1' ? 1 : 2);
    var matchIdx =
        matchData.getMatchIndex('all', selectedLeague == 'K리그1' ? 1 : 2);

    for (int i = 0; i < leagueLen; i++) {
      bool flag = true;
      for (var item in matchIdx[i]) {
        if (int.parse(today) <= int.parse(item.data)) {
          flag = false;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo((size.height * .27 + 30) * i);
          });
          break;
        }
      }
      if (!flag) {
        break;
      }
    }
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "경기 일정",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 14),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      style: elevatedStyle, //Elevated Button Background
                      onPressed: () {}, //make onPressed callback empty
                      child: DropdownButton(
                        isDense: true,
                        style: textStyle, //Dropdown font color
                        dropdownColor:
                            Colors.white, //dropdown menu background color
                        icon: iconStyle, //dropdown indicator icon
                        value: selectedLeague,
                        onChanged: (value) {
                          setState(() {
                            selectedLeague = value.toString();
                            selectedLeague == 'K리그1'
                                ? selectedTeam = k1[0].id
                                : selectedTeam = k2[0].id;
                            filtering = false;
                          });
                        },
                        items: league.map((item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item));
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: elevatedStyle, //Elevated Button Background
                      onPressed: () {}, //make onPressed callback empty
                      child: DropdownButton(
                          isDense: true,
                          style: textStyle, //Dropdown font color
                          dropdownColor:
                              Colors.white, //dropdown menu background color
                          icon: iconStyle,
                          value: selectedTeam,
                          onChanged: (value) {
                            setState(() {
                              selectedTeam = value!;
                              filtering = true;
                            });
                          },
                          items: selectedLeague == 'K리그1'
                              ? k1.map((e) {
                                  return DropdownMenuItem(
                                      value: e.id, child: Text(e.fullName));
                                }).toList()
                              : k2.map((e) {
                                  return DropdownMenuItem(
                                      value: e.id, child: Text(e.fullName));
                                }).toList()),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (body) => const MyTeam()),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(14, 32, 87, 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "MY팀",
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 10),
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
              flex: 1,
              child: filtering
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredTeam.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FilteredBox(
                            teamInfoList: teamInfoList,
                            size: size,
                            info: filteredTeam[index]);
                      })
                  : ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: leagueLen,
                      itemBuilder: (BuildContext context, int index) {
                        return MatchBox(
                            teamInfoList: teamInfoList,
                            size: size,
                            info: matchIdx[index]);
                      }),
            )
          ],
        ),
      ),
    );
  }
}

class MatchBox extends StatelessWidget {
  const MatchBox({
    super.key,
    required this.teamInfoList,
    required this.size,
    required this.info,
  });

  final List<TeamInfo> teamInfoList;
  final Size size;
  final List info;

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
      height: size.height * 0.27,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
          physics: const ClampingScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getDate(info.first.data),
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 13)),
                  ),
                  const SizedBox(height: 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('H',
                            style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 12),
                                color: Colors.blue,
                                fontWeight: FontWeight.w600)),
                        Text('A',
                            style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 12),
                                color: Colors.red,
                                fontWeight: FontWeight.w600)),
                      ]),
                  ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: info.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  convertTime(info[index].time),
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 11)),
                                ),
                                SizedBox(
                                    width: size.width * 0.08,
                                    height: size.width * 0.08,
                                    child: Image.network(
                                        teamInfoList[info[index].team1]
                                            .logoImg)),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        teamInfoList[info[index].team1].name,
                                        style: TextStyle(
                                            fontSize: const AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 12)),
                                        textAlign: TextAlign.center,
                                      ),
                                      getScore(info.first.data)
                                          ? Text(
                                              ' ${info[index].score1} : ${info[index].score2} ',
                                              style: TextStyle(
                                                  fontSize:
                                                      const AdaptiveTextSize()
                                                          .getadaptiveTextSize(
                                                              context, 13)))
                                          : Text(' vs ',
                                              style: TextStyle(
                                                  fontSize:
                                                      const AdaptiveTextSize()
                                                          .getadaptiveTextSize(
                                                              context, 13))),
                                      Text(
                                        teamInfoList[info[index].team2].name,
                                        style: TextStyle(
                                            fontSize: const AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 12)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                                SizedBox(
                                    width: size.width * 0.08,
                                    height: size.width * 0.08,
                                    child: Image.network(
                                        teamInfoList[info[index].team2]
                                            .logoImg)),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MatchDetail(
                                                date: getDate(info.first.data),
                                                time: info[index].time,
                                                team1: info[index].team1,
                                                team2: info[index].team2,
                                                score1: info[index].score1,
                                                score2: info[index].score2)));
                                    // 회원정보 수정 페이지로 이동
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
                                      size: 15,
                                    ),
                                  ),
                                )
                              ],
                            ));
                      }),
                ]);
          }),
    );
  }
}

class FilteredBox extends StatelessWidget {
  const FilteredBox({
    super.key,
    required this.teamInfoList,
    required this.size,
    required this.info,
  });
  final List<TeamInfo> teamInfoList;
  final Size size;
  final MatchModel info;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
            getDate(info.data),
            style: TextStyle(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 13)),
          ),
          const SizedBox(height: 5),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('H',
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12),
                        color: Colors.blue,
                        fontWeight: FontWeight.w600)),
                Text('A',
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12),
                        color: Colors.red,
                        fontWeight: FontWeight.w600)),
              ]),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${info.time}',
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12)),
                  ),
                  SizedBox(
                      width: size.width * 0.08,
                      height: size.width * 0.08,
                      child: Image.network(teamInfoList[info.team1!].logoImg)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          teamInfoList[info.team1!].name,
                          style: TextStyle(
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 13)),
                          textAlign: TextAlign.center,
                        ),
                        getScore(info.data)
                            ? Text(
                                ' ${info.score1} : ${info.score2} ',
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 13)),
                              )
                            : Text(' vs ',
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 13))),
                        Text(
                          teamInfoList[info.team2!].name,
                          style: TextStyle(
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 12)),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                  SizedBox(
                      width: size.width * 0.08,
                      height: size.width * 0.08,
                      child: Image.network(teamInfoList[info.team2!].logoImg)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(14, 32, 87, 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Icon(
                      CupertinoIcons.paperplane,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ))
        ]));
  }
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});
  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(
      color: Color.fromARGB(255, 67, 67, 67),
      width: 1.0,
    );
    var textStyle = TextStyle(
        fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 12),
        color: const Color.fromARGB(255, 67, 67, 67));
    var elevatedStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        backgroundColor: Colors.white,
        side: borderSide);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '경기 일정',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ElevatedButton(
                      style: elevatedStyle, //Elevated Button Background
                      onPressed: () {}, //make onPressed callback empty
                      child: Text('K리그1', style: textStyle)),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: elevatedStyle, //Elevated Button Background
                      onPressed: () {}, //make onPressed callback empty
                      child: Text('강원 FC', style: textStyle)),
                ]),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 221, 221, 221),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.favorite,
                      color: Color.fromRGBO(255, 0, 0, 0.3)),
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}

String getName(String selectedTeam) {
  return selectedTeam.replaceAll('\n', ' ');
}

String getDate(data) {
  return "${data[0]}${data[1]}년 ${data[2]}${data[3]}월 ${data[4]}${data[5]}일";
}

bool getScore(String? time) {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyMMdd');
  int today = int.parse(formatter.format(now));
  return today >= int.parse(time!) ? true : false;
}
