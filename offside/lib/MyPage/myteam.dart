import 'package:flutter/material.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyTeam extends ConsumerStatefulWidget {
  const MyTeam({super.key});

  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends ConsumerState {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = ref.watch(userViewModelProvider);
    var matchData = ref.watch(matchViewModelProvider);
    String team = user.user!.team!;
    var myTeam = matchData.getMyTeam(team);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                      child: Image.asset(teamTransfer[team]['img'])),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    team,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
          Container(
            width: size.width,
            margin: const EdgeInsets.fromLTRB(10, 0, 20, 10),
            child: Text(
              '${myTeam['win']}W${myTeam['lose']}L${myTeam['draw']}D',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            height: size.height,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: myTeam['team'].length,
                itemBuilder: (context, index) => ResultBox(
                    size: size, info: myTeam['team'][index], team: team)),
          )
        ],
      ),
    );
  }
}

class ResultBox extends StatelessWidget {
  const ResultBox(
      {super.key, required this.size, required this.info, required this.team});

  final Size size;
  final List<dynamic> info;
  final String team;

  String getDate(data) {
    return "${data[0]}${data[1]}.${data[2]}${data[3]}.${data[4]}${data[5]}";
  }

  int resultColor(String date, result) {
    String today = DateFormat('yyMMdd').format(DateTime.now());
    if (int.parse(date) <= int.parse(today)) {
      if (result == 1) {
        return 0xffddefff;
      } else if (result == 2) {
        return 0xffffeeeb;
      } else {
        return 0xfffff6d7;
      }
    } else {
      return 0xffffffff;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
        decoration: BoxDecoration(
            color: Color(resultColor(info[0].data, info[1])),
            border: const Border(
              bottom: BorderSide(width: 1, color: Colors.grey),
            )),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            '[${getDate(info[0].data)}]',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${info[0].score1}',
                      style: const TextStyle(fontSize: 15)),
                  SizedBox(
                      width: size.width * 0.08,
                      height: size.width * 0.08,
                      child: Image.asset(teamTransfer[info[0].team1]['img'])),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          teamTransfer[info[0].team1]['name']!,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          ' vs ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          teamTransfer[info[0].team2]['name']!,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                  SizedBox(
                      width: size.width * 0.08,
                      height: size.width * 0.08,
                      child: Image.asset(teamTransfer[info[0].team2]['img'])),
                  Text('${info[0].score2}',
                      style: const TextStyle(fontSize: 15)),
                ],
              )),
        ]));
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
