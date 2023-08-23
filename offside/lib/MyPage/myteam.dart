import 'package:flutter/material.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyTeam extends ConsumerStatefulWidget {
  const MyTeam({super.key});

  @override
  _MyTeamState createState() => _MyTeamState();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class _MyTeamState extends ConsumerState {
  @override
  void initState() {
    super.initState();
  }

  double getAdaptiveTextSize(BuildContext context, double value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = ref.watch(userViewModelProvider);
    var matchData = ref.watch(matchViewModelProvider);
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    int team = user.user!.team!;
    var myTeam = matchData.getMyTeam(team);

    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                      child: Image.network(
                          teamInfoList[user.user!.team!].logoImg)),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    teamInfoList[user.user!.team!].fullName,
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 16),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
          Container(
            width: size.width,
            margin: const EdgeInsets.fromLTRB(10, 0, 20, 10),
            child: Text(
              '${myTeam['win']}승 ${myTeam['draw']}무 ${myTeam['lose']}패',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: const AdaptiveTextSize()
                      .getadaptiveTextSize(context, 13)),
            ),
          ),
          SizedBox(
            height: size.height,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: myTeam['team'].length,
                itemBuilder: (context, index) => ResultBox(
                    teamInfoList: teamInfoList,
                    size: size,
                    info: myTeam['team'][index],
                    team: teamInfoList[user.user!.team!].fullName)),
          )
        ],
      ),
    );
  }
}

class ResultBox extends StatelessWidget {
  const ResultBox(
      {super.key,
      required this.teamInfoList,
      required this.size,
      required this.info,
      required this.team});

  final List<TeamInfo> teamInfoList;
  final Size size;
  final List<dynamic> info;
  final String team;

  String getDate(data) {
    return "${data[0]}${data[1]}년 ${data[2]}${data[3]}월 ${data[4]}${data[5]}일";
  }

  int resultColor(String date, result) {
    String today = DateFormat('yyMMdd').format(DateTime.now());
    if (int.parse(date) <= int.parse(today)) {
      if (result == 1) {
        return 0xffddefff;
      } else if (result == 2) {
        return 0xffffeeeb;
      } else {
        return 0xf5f5f5f5;
      }
    } else {
      return 0xffffffff;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: size.width,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 30),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: Color(resultColor(info[0].data, info[1])),
                borderRadius: BorderRadius.circular(20)
                // border: const Border(
                //   bottom: BorderSide(width: 1, color: Colors.grey),
                // ),
                ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${getDate(info[0].data)}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${info[0].score1}',
                              style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 16),
                                  fontWeight: FontWeight.w600)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: size.width * 0.1,
                                  height: size.width * 0.1,
                                  child: Image.asset(
                                      teamTransfer[info[0].team1]['img'])),
                              Text(
                                teamTransfer[info[0].team1]['name']!,
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 12),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Text(
                            ' vs ',
                            style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 16),
                                fontWeight: FontWeight.w600),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: size.width * 0.1,
                                  height: size.width * 0.1,
                                  child: Image.asset(
                                      teamTransfer[info[0].team2]['img'])),
                              Text(
                                teamTransfer[info[0].team2]['name']!,
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 12),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Text('${info[0].score2}',
                              style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 16),
                                  fontWeight: FontWeight.w600)),
                        ],
                      )),
                ])),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Divider(
            height: 15, // 구분선 위 아래의 간격
            thickness: 1, // 구분선의 두께
            color: Colors.grey, // 구분선의 색상
          ),
        ),
      ],
    );
  }
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle =
        TextStyle(fontSize: 12, color: Color.fromARGB(255, 67, 67, 67));
    return const Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '로딩중',
              style: textStyle,
            ),
          ],
        ),
        // MatchBox(size: size)
      )
    ]);
  }
}
