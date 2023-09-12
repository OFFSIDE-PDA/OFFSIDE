import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/KLeague/TeamInfo.dart';

class KLeague extends StatelessWidget {
  const KLeague({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          child: Top(),
        ),
        SizedBox(
          // height: 450,
          child: KLeagueOne(),
        ),
        SizedBox(
          child: KLeagueTwo(),
        )
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
  const Top({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/mark2.png'))),
    );
  }
}

class KLeagueOne extends ConsumerWidget {
  const KLeagueOne({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    final k1 = teamInfoList.where((element) => element.league == 1).toList();

    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      color: const Color.fromRGBO(18, 32, 84, 1),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Text(
                "K 리그 1",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 13),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Team(id: 1, team: k1[0]),
                    Team(id: 2, team: k1[1]),
                    Team(id: 3, team: k1[2]),
                    Team(id: 4, team: k1[3])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Team(id: 5, team: k1[4]),
                    Team(id: 6, team: k1[5]),
                    Team(id: 7, team: k1[6]),
                    Team(id: 8, team: k1[7])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Team(id: 9, team: k1[8]),
                    Team(id: 10, team: k1[9]),
                    Team(id: 11, team: k1[10]),
                    Team(id: 12, team: k1[11])
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KLeagueTwo extends ConsumerWidget {
  const KLeagueTwo({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    final k2 = teamInfoList.where((element) => element.league == 2).toList();
    return Container(
      width: double.infinity,
      height: 570,
      alignment: Alignment.topLeft,
      child: Column(children: [
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
            child: Text(
              "K 리그 2",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 13),
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(18, 32, 84, 1)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Team(id: 13, team: k2[0]),
                  Team(id: 14, team: k2[1]),
                  Team(id: 15, team: k2[2]),
                  Team(id: 16, team: k2[3])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Team(id: 17, team: k2[4]),
                  Team(id: 18, team: k2[5]),
                  Team(id: 19, team: k2[6]),
                  Team(id: 20, team: k2[7])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Team(id: 21, team: k2[8]),
                  Team(id: 22, team: k2[9]),
                  Team(id: 23, team: k2[10]),
                  Team(id: 24, team: k2[11])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Team(id: 25, team: k2[12])],
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class Team extends StatelessWidget {
  const Team({super.key, required this.id, required this.team});

  final int id;
  final TeamInfo team;

  String convertedName(name) {
    if (name.length >= 7) {
      return name.replaceFirst(' ', '\n');
    }

    return name;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return (SizedBox(
      height: 120,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamInfoPage(team: team)));
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              width: size.width * 0.13,
              height: size.width * 0.13,
              decoration: BoxDecoration(
                  color: id >= 13
                      ? const Color.fromRGBO(18, 32, 84, 1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              child: Image.network(team.logoImg),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              convertedName(team.middleName),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: id >= 13
                      ? const Color.fromRGBO(18, 32, 84, 1)
                      : Colors.white,
                  fontSize: const AdaptiveTextSize()
                      .getadaptiveTextSize(context, 11)),
            ),
          )
        ],
      ),
    ));
  }
}
