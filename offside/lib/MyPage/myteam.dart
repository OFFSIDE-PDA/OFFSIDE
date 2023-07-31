import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offside/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

class MyTeam extends ConsumerStatefulWidget {
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends ConsumerState {
  var team = '울산 현대 FC';
  String date = DateFormat('MM월 dd일 hh:mm').format(DateTime.now());

  late Future<List<List>> kLeagueOne;
  late Future<List<List>> kLeagueTwo;

  @override
  void initState() {
    super.initState();
    kLeagueOne = getMatchData(1);
    kLeagueTwo = getMatchData(2);
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int num = 0;
    var user = ref.watch(userViewModelProvider);
    team = user.user!.team!;

    const borderSide = BorderSide(
      color: Color.fromARGB(255, 67, 67, 67),
      width: 1.0,
    );
    const iconStyle =
        Icon(Icons.expand_more, color: Color.fromARGB(255, 67, 67, 67));
    const textStyle =
        TextStyle(fontSize: 12, color: Color.fromARGB(255, 67, 67, 67));

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: size.width * 0.08,
                height: size.width * 0.08,
                child: teamImg[team]),
            Text(
              team,
              style: textStyle,
            ),
          ]),
          FutureBuilder<List<List>>(
            future: team1.contains(team) ? kLeagueOne : kLeagueTwo,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                List<List> matches = snapshot.data!;
                if (matches[num][0].team1 == 'team' ||
                    matches[num][0].team2 == 'team') {
                  num++;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(child: teamImg[team]),
                            Text(
                              team,
                              style: textStyle,
                            ),
                            SizedBox(
                              height: size.height,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: matches.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print(matches[index]);
                                    return MatchBox(
                                        size: size, info: matches[index]);
                                  }),
                            )
                            // MatchBox(size: size)
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  num++;
                }
              } else if (snapshot.hasError) {
                return const Text('error');
              }
              return const DefaultWidget();
            }),
          ),
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
  "대전 하나 시티즌",
  "FC 서울",
  "수원 삼성 블루윙즈",
  "수원 FC",
  "울산 현대",
  "인천 유나이티드",
  "전북 현대 모터스",
  "제주 유나이티드",
  "포항 스틸러스"
];
List<String> team2 = <String>[
  "경남 FC",
  "김천 상무",
  "김포 FC",
  "부산 아이파크",
  "부천 FC 1995",
  "서울 이랜드",
  "성남 FC",
  "안산 그리너스",
  "FC 안양",
  "전남 드래곤즈",
  "충남 아산 FC",
  "충북 청주 FC",
  "천안 시티 FC"
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
