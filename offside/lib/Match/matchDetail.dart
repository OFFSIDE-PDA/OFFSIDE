import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchDetail extends StatelessWidget {
  const MatchDetail(
      {Key? key,
      required this.date,
      required this.time,
      required this.team1,
      required this.team2,
      this.matchId,
      this.score1,
      this.score2,
      this.league})
      : super(key: key);

  final String date;
  final String time;
  final int team1;
  final int team2;
  final int? matchId;
  final int? score1;
  final int? score2;
  final int? league;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(),
        Top(
            date: date,
            time: time,
            team1: team1,
            team2: team2,
            score1: score1,
            score2: score2),
        Bottom(team1: team1, team2: team2, matchId: matchId!, league: league!)
      ],
    );
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class Top extends ConsumerWidget {
  const Top(
      {super.key,
      required this.date,
      required this.time,
      required this.team1,
      required this.team2,
      this.score1,
      this.score2});

  final String date;
  final String time;
  final int team1;
  final int team2;
  final int? score1;
  final int? score2;

  String convertTime(date) {
    var tmp = int.parse(date[0] + date[1]);
    var returnString = '';
    if (tmp < 12) {
      returnString = (tmp + 12).toString();
    }

    return "$returnString시 ${date[2]}${date[3]}분";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final teamInfoList = ref.read(teamInfoViewModelProvider).teamInfoList;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 12))),
              SizedBox(width: size.width * 0.04),
              Text(convertTime(time),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 12))),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                size.width * 0.2, size.height * 0.03, size.width * 0.2, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        child: Image.network(teamInfoList[team1].logoImg)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      teamInfoList[team1].middleName,
                      style: TextStyle(
                          color: Color(teamInfoList[team1].color[0]),
                          fontWeight: FontWeight.w600,
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12)),
                    )
                  ],
                ),
                getScore(date)
                    ? Text(
                        ' $score1 : $score2 ',
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14),
                            fontWeight: FontWeight.w600),
                      )
                    : Text(
                        ' vs ',
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 13),
                            fontWeight: FontWeight.w600),
                      ),
                Column(
                  children: [
                    SizedBox(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        child: Image.network(teamInfoList[team2].logoImg)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      teamInfoList[team2].middleName,
                      style: TextStyle(
                          color: Color(teamInfoList[team2].color[0]),
                          fontWeight: FontWeight.w600,
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 11)),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey, // 색상 지정
            thickness: 1, // 두께 지정
            indent: 10, // 시작 여백 지정
            endIndent: 30, // 끝 여백 지정
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      teamInfoList[team1].stadiumImg,
                      fit: BoxFit.fill,
                      width: size.width * 0.7,
                      height: size.height * 0.15,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on,
                          size: 20, color: Color.fromRGBO(50, 77, 177, 1)),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        teamInfoList[team1].stadium,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12)),
                      ),
                    ],
                  ),
                ]),
          )
        ],
      ),
    );
  }
}

class Bottom extends ConsumerWidget {
  const Bottom(
      {super.key,
      required this.team1,
      required this.team2,
      required this.matchId,
      required this.league});

  final int team1;
  final int team2;
  final int matchId;
  final int league;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamInfoList = ref.read(teamInfoViewModelProvider).teamInfoList;
    final recordData =
        ref.read(matchViewModelProvider).getRecord(league, team1, team2);
    return (FutureBuilder(
        future: recordData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
          return Expanded(
            child: Container(
              color: const Color.fromRGBO(18, 32, 84, 1),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "통산전적",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 14),
                                fontWeight: FontWeight.w600),
                          ),
                          const Divider(
                            color: Colors.white, // 색상 지정
                            thickness: 2, // 두께 지정
                          ),
                          //통산전적을 아직 불러오지 못했다면 로딩 위젯 출력
                          snapshot.hasData == false
                              ? const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${teamInfoList[team1].middleName} ${snapshot.data[0].score1}승',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 12),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${snapshot.data[0].draw}무',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 12),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${teamInfoList[team2].middleName} ${snapshot.data[0].score2}승',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 12),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "최근 10경기 전적",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 14),
                                fontWeight: FontWeight.w600),
                          ),
                          const Divider(
                            color: Colors.white, // 색상 지정
                            thickness: 2, // 두께 지정
                          ),
                          //통산전적을 아직 불러오지 못했다면 로딩 위젯 출력
                          snapshot.hasData == false
                              ? const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${teamInfoList[team1].middleName} ${snapshot.data[1].score1}승',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 12),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${snapshot.data[1].draw}무',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 12),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${teamInfoList[team2].middleName} ${snapshot.data[1].score2}승',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 12),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                )
                        ],
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            launchUrl(
                              Uri.parse(
                                  "https://www.kleague.com/match.do?year=2023&leagueId=$league&gameId=$matchId&meetSeq=$league&startTabNum=1"),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // 배경색 설정
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          child: const Text(
                            "경기 자세히 보기",
                            style: TextStyle(
                              color: Color.fromRGBO(18, 32, 84, 1),
                              // 텍스트 색상 변경 (흰색 배경 위에 흰색 텍스트는 보이지 않기 때문에 색상 변경)
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          );
        }));
  }
}

int convertDateToInt(String date) {
  // Remove non-numeric characters from the date string
  String numericDate = date.replaceAll(RegExp(r'[^0-9]'), '');

  // Extract year, month, and day from the numeric date string
  int year = int.parse(numericDate.substring(0, 2));
  int month = int.parse(numericDate.substring(2, 4));
  int day = int.parse(numericDate.substring(4, 6));

  // Combine year, month, and day into a single integer
  int convertedDate = year * 10000 + month * 100 + day;

  return convertedDate;
}

bool getScore(String? time) {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyMMdd');
  int today = int.parse(formatter.format(now));
  int convertTime = convertDateToInt(time!);
  return today >= convertTime ? true : false;
}
