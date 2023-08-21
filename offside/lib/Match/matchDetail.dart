import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/MyPage/myteam.dart';
import 'package:offside/data/model/match_model.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class MatchDetail extends StatelessWidget {
  const MatchDetail(
      {Key? key,
      required this.date,
      required this.time,
      required this.team1,
      required this.team2,
      this.score1,
      this.score2})
      : super(key: key);

  final String date;
  final String time;
  final String team1;
  final String team2;
  final String? score1;
  final String? score2;
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
        Bottom(team1: team1, team2: team2)
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

class Top extends StatelessWidget {
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
  final String team1;
  final String team2;
  final String? score1;
  final String? score2;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 13))),
              Text(time,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 13))),
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
                        child: Image.asset(teamTransfer[team1]['img'])),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      teamTransfer[team1]['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12)),
                    )
                  ],
                ),
                getScore(date)
                    ? Text(
                        ' ${score1} : ${score2} ',
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14),
                            fontWeight: FontWeight.w600),
                      )
                    : Text(
                        ' vs ',
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14),
                            fontWeight: FontWeight.w600),
                      ),
                Column(
                  children: [
                    SizedBox(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        child: Image.asset(teamTransfer[team2]['img'])),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      teamTransfer[team2]['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 11)),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey, // 색상 지정
            thickness: 1, // 두께 지정
            indent: 10, // 시작 여백 지정
            endIndent: 20, // 끝 여백 지정
          ),
          Container(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      teamTransfer[team1]['stadium_img'],
                      fit: BoxFit.fill,
                      width: size.width * 0.7,
                      height: size.height * 0.15,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    '< ${teamTransfer[team1]['stadium']} >',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 13)),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}

class Bottom extends StatelessWidget {
  const Bottom({
    super.key,
    required this.team1,
    required this.team2,
  });

  final String team1;
  final String team2;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return (Expanded(
      child: Container(
        color: const Color.fromRGBO(18, 32, 84, 1),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Text(
                        "통산전적",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: Colors.white, // 색상 지정
                      thickness: 2, // 두께 지정
                      indent: 35, // 시작 여백 지정
                      endIndent: 35, // 끝 여백 지정
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${team1} 1승',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 12),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '3무',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 12),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${team2} 5승',
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Text(
                        "최근 10경기 전적",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: Colors.white, // 색상 지정
                      thickness: 2, // 두께 지정
                      indent: 35, // 시작 여백 지정
                      endIndent: 35, // 끝 여백 지정
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${team1} 1승',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 12),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '3무',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 12),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${team2} 5승',
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
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // 배경색 설정
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    ));
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
