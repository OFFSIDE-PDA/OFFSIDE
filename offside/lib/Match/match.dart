import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/MyPage/myteam.dart';
import 'package:offside/data/model/match_model.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:intl/intl.dart';

class Match extends ConsumerStatefulWidget {
  const Match({super.key});

  @override
  _Match createState() => _Match();
}

class _Match extends ConsumerState {
  List<String> league = ["K리그1", "K리그2"];
  String selectedLeague = 'K리그1';
  String selectedTeam = '강원 FC';
  bool filtering = false;

  @override
  void initState() {
    super.initState();
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
    const textStyle =
        TextStyle(fontSize: 12, color: Color.fromARGB(255, 67, 67, 67));
    var elevatedStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        backgroundColor: Colors.white,
        side: borderSide);
    var matchData = ref.watch(matchViewModelProvider);
    var filteredTeam = matchData.getFilteredTeams(
        selectedLeague == 'K리그1' ? 1 : 2, getName(selectedTeam));
    var leagueLen =
        matchData.getLeagueLength('all', selectedLeague == 'K리그1' ? 1 : 2);
    var matchIdx =
        matchData.getMatchIndex('all', selectedLeague == 'K리그1' ? 1 : 2);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '경기 일정',
                  style: textStyle,
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
                                    ? selectedTeam = '강원 FC'
                                    : selectedTeam = '경남 FC';
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
                                  selectedTeam = value.toString();
                                  filtering = true;
                                });
                              },
                              items: selectedLeague == 'K리그1'
                                  ? teamK1.map((e) {
                                      return DropdownMenuItem(
                                          value: e, child: Text(e));
                                    }).toList()
                                  : teamK2.map((e) {
                                      return DropdownMenuItem(
                                          value: e, child: Text(e));
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(33, 58, 135, 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Text(
                          "MY팀",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height,
                  child: filtering
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: filteredTeam.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FilteredBox(
                                size: size, info: filteredTeam[index]);
                          })
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: leagueLen,
                          itemBuilder: (BuildContext context, int index) {
                            return MatchBox(size: size, info: matchIdx[index]);
                          }),
                )
                // MatchBox(size: size)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MatchBox extends StatelessWidget {
  const MatchBox({
    super.key,
    required this.size,
    required this.info,
  });

  final Size size;
  final List info;

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
            '[${getDate(info.first.data)}]',
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
              itemCount: info.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${info[index].time}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: Image.asset(
                                teamTransfer[info[index].team1]['img'])),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                // transferName[info[index].team1]!,
                                teamTransfer[info[index].team1]['name'],
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              getScore(info.first.data)
                                  ? Text(
                                      ' ${info[index].score1} : ${info[index].score2} ',
                                      style: const TextStyle(fontSize: 13),
                                    )
                                  : const Text(
                                      ' vs ',
                                      style: TextStyle(fontSize: 13),
                                    ),
                              Text(
                                teamTransfer[info[index].team2]['name'],
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                        SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: Image.asset(
                                teamTransfer[info[index].team2]['img'])),
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

class FilteredBox extends StatelessWidget {
  const FilteredBox({
    super.key,
    required this.size,
    required this.info,
  });
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
            '[${getDate(info.data)}]',
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
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${info.time}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                      width: size.width * 0.08,
                      height: size.width * 0.08,
                      child: Image.asset(teamTransfer[info.team1]['img'])),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          teamTransfer[info.team1]['name'],
                          style: const TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        getScore(info.data)
                            ? Text(
                                ' ${info.score1} : ${info.score2} ',
                                style: const TextStyle(fontSize: 13),
                              )
                            : const Text(
                                ' vs ',
                                style: TextStyle(fontSize: 13),
                              ),
                        Text(
                          teamTransfer[info.team2]['name'],
                          style: const TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                  SizedBox(
                      width: size.width * 0.08,
                      height: size.width * 0.08,
                      child: Image.asset(teamTransfer[info.team2]['img'])),
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
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
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
    const textStyle =
        TextStyle(fontSize: 12, color: Color.fromARGB(255, 67, 67, 67));
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
            const Text(
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
                      child: const Text('K리그1', style: textStyle)),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: elevatedStyle, //Elevated Button Background
                      onPressed: () {}, //make onPressed callback empty
                      child: const Text('강원 FC', style: textStyle)),
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
  return "${data[0]}${data[1]}.${data[2]}${data[3]}.${data[4]}${data[5]}";
}

bool getScore(String? time) {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyMMdd');
  int today = int.parse(formatter.format(now));
  return today >= int.parse(time!) ? true : false;
}
