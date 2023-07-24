import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

Future<List<List>> getMatchData(int league) async {
  final firestore = FirebaseFirestore.instance;
  var result = (league == 1)
      ? await firestore.collection('match').doc('kLeague1').get()
      : await firestore.collection('match').doc('kLeague2').get();
  var data = result.data()?['match'];
  List<List> kLeague = [];
  var lastDay = "";
  data.forEach((dynamic e) {
    lastDay = e['data'];
    if (kLeague.isEmpty) {
      kLeague.add([
        MatchData(e['data'], e['score2'], e['team1'], e['team2'], e['location'],
            e['time'], e['score1'])
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
  });

  return kLeague;
}

class _ScheduleState extends State<Schedule> {
  late Future<List<List>> kLeagueOne;
  late Future<List<List>> kLeagueTwo;
  List<String> league = ["K리그1", "K리그2"];
  String selectedLeague = 'K리그1';
  String selectedTeam = '강원 FC';
  bool myTeam = false;

  @override
  void initState() {
    super.initState();
    kLeagueOne = getMatchData(1);
    kLeagueTwo = getMatchData(2);
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
    return FutureBuilder<List<List>>(
      future: selectedLeague == "K리그1" ? kLeagueOne : kLeagueTwo,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          List<List> matches = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                style:
                                    elevatedStyle, //Elevated Button Background
                                onPressed:
                                    () {}, //make onPressed callback empty
                                child: DropdownButton(
                                  isDense: true,
                                  style: textStyle, //Dropdown font color
                                  dropdownColor: Colors
                                      .white, //dropdown menu background color
                                  icon: iconStyle, //dropdown indicator icon
                                  value: selectedLeague,
                                  onChanged: (value) {
                                    setState(() {
                                      print("pressed");
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
                                style:
                                    elevatedStyle, //Elevated Button Background
                                onPressed:
                                    () {}, //make onPressed callback empty
                                child: DropdownButton(
                                    isDense: true,
                                    style: textStyle, //Dropdown font color
                                    dropdownColor: Colors
                                        .white, //dropdown menu background color
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
                            itemCount: matches.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(matches[index]);
                              return MatchBox(size: size, info: matches[index]);
                            }),
                      )
                      // MatchBox(size: size)
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        }
        return const DefaultWidget();
      }),
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

List<String> team1 = <String>[
  "강원 FC",
  "광주 FC",
  "대구 FC",
  "대전\n하나 시티즌",
  "FC 서울",
  "수원 삼성\n블루윙즈",
  "수원 FC",
  "울산 현대",
  "인천\n유나이티드",
  "전북 현대\n모터스",
  "제주\n유나이티드",
  "포항\n스틸러스"
];
List<String> team2 = <String>[
  "경남 FC",
  "김천 상무",
  "김포 FC",
  "부산\n아이파크",
  "부천 FC\n1995",
  "서울 이랜드",
  "성남 FC",
  "안산\n그리너스",
  "FC 안양",
  "전남\n드래곤즈",
  "충남\n아산 FC",
  "충북\n청주 FC",
  "천안\n시티 FC"
];

Map<String, String> transferName = {
  '강원 FC': '강원',
  '광주 FC': '광주',
  '대구 FC': '대구',
  '대전 하나 시티즌': '대전',
  'FC 서울': '서울',
  '수원 삼성 블루윙즈': '수원',
  '수원 FC': '수원FC',
  '울산 현대': '울산',
  '인천 유나이티드': '인천',
  '전북 현대 모터스': '전북',
  '제주 유나이티드': '제주',
  '포항 스틸러스': '포항',
  '경남 FC': '경남',
  '김천 상무 FC': '김천',
  '김포 FC': '김포',
  '부산 아이파크': '부산',
  '부천 FC 1995': '부천',
  '서울 이랜드 FC': '서울E',
  '성남 FC': '성남',
  '안산 그리너스 FC': '안산',
  'FC 안양': '안양',
  '전남 드래곤즈': '전남',
  '충남 아산 FC': '아산',
  '충북 청주 FC': '청주',
  '천안 시티 FC': '천안'
};

Map<String, dynamic> teamImg = {
  '강원 FC': Image.asset('images/K1_png/Gangwon.png'),
  '광주 FC': Image.asset('images/K1_png/GwangJu.png'),
  '대구 FC': Image.asset('images/K1_png/Daegu.png'),
  '대전 하나 시티즌': Image.asset('images/K1_png/Daejeon.png'),
  'FC 서울': Image.asset('images/K1_png/Seoul.png'),
  '수원 삼성 블루윙즈': Image.asset('images/K1_png/suwon.png'),
  '수원 FC': Image.asset('images/K1_png/suwonFC.png'),
  '울산 현대': Image.asset('images/K1_png/ulsan.png'),
  '인천 유나이티드': Image.asset('images/K1_png/incheon.png'),
  '전북 현대 모터스': Image.asset('images/K1_png/jeonbuk.png'),
  '제주 유나이티드': Image.asset('images/K1_png/jeju.png'),
  '포항 스틸러스': Image.asset('images/K1_png/pohang.png'),
  '경남 FC': Image.asset('images/K2_png/kn.png'),
  '김천 상무 FC': Image.asset('images/K2_png/kimcheon.png'),
  '김포 FC': Image.asset('images/K2_png/kimpo.png'),
  '부산 아이파크': Image.asset('images/K2_png/busan.png'),
  '부천 FC 1995': Image.asset('images/K2_png/bc.jpg'),
  '서울 이랜드 FC': Image.asset('images/K2_png/seoulE.png'),
  '성남 FC': Image.asset('images/K2_png/seongnam.png'),
  '안산 그리너스 FC': Image.asset('images/K2_png/ansan.png'),
  'FC 안양': Image.asset('images/K2_png/anyang.png'),
  '전남 드래곤즈': Image.asset('images/K2_png/jeonnam.png'),
  '충남 아산 FC': Image.asset('images/K2_png/asan.png'),
  '충북 청주 FC': Image.asset('images/K2_png/chungju.png'),
  '천안 시티 FC': Image.asset('images/K2_png/cheonan.png')
};
