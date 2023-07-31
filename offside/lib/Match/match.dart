import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:offside/data/view/match_view_model.dart';

class Match extends ConsumerStatefulWidget {
  @override
  _Match createState() => _Match();
}

class _Match extends ConsumerState<Match> {
  List<String> league = ["K리그1", "K리그2"];
  String selectedLeague = 'K리그1';
  String selectedTeam = '강원 FC';
  bool myTeam = false;

  @override
  void initState() {
    super.initState();
  }

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
    final matchData = ref.read(matchViewModelProvider);
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
                                });
                              },
                              items: selectedLeague == 'K리그1'
                                  ? team1.map((e) {
                                      return DropdownMenuItem(
                                          value: e, child: Text(e));
                                    }).toList()
                                  : team2.map((e) {
                                      return DropdownMenuItem(
                                          value: e, child: Text(e));
                                    }).toList()),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          myTeam = !myTeam;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 221, 221, 221),
                            shape: BoxShape.circle),
                        child: Icon(Icons.favorite,
                            color: myTeam == true
                                ? Colors.red
                                : const Color.fromRGBO(255, 0, 0, 0.3)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: matchData.getLeagueLength(
                          'all', selectedLeague == 'K리그1' ? 1 : 2),
                      itemBuilder: (BuildContext context, int index) {
                        return MatchBox(
                            size: size,
                            info: matchData.getMatchIndex('all',
                                selectedLeague == 'K리그1' ? 1 : 2, index));
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
                            child: teamImg[info[index].team1]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                transferName[info[index].team1]!,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                ' vs ',
                                style: TextStyle(fontSize: 13),
                              ),
                              Text(
                                transferName[info[index].team2]!,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                        SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: teamImg[info[index].team2]),
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

getDate(data) {
  return "${data[0]}${data[1]}.${data[2]}${data[3]}.${data[4]}${data[5]}";
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

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

        // MatchBox(size: size)
      )
    ]);
  }
}
