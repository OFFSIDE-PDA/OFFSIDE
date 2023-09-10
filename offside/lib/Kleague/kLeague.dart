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
          image: DecorationImage(image: AssetImage('images/mark2.png'))),
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
                    team(1, context, k1[0]),
                    team(2, context, k1[1]),
                    team(3, context, k1[2]),
                    team(4, context, k1[3])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(5, context, k1[4]),
                    team(6, context, k1[5]),
                    team(7, context, k1[6]),
                    team(8, context, k1[7])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(9, context, k1[8]),
                    team(10, context, k1[9]),
                    team(11, context, k1[10]),
                    team(12, context, k1[11])
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
                  team(13, context, k2[0]),
                  team(14, context, k2[1]),
                  team(15, context, k2[2]),
                  team(16, context, k2[3])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  team(17, context, k2[4]),
                  team(18, context, k2[5]),
                  team(19, context, k2[6]),
                  team(20, context, k2[7])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  team(21, context, k2[8]),
                  team(22, context, k2[9]),
                  team(23, context, k2[10]),
                  team(24, context, k2[11])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  team(25, context, k2[12]),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}

Widget team(int id, BuildContext context, TeamInfo team) {
// String convertedName(name){
//     if(name.len() >= 7 ){
//       return name.replaceFirst(' ', '\n');
//     }
//   }

  var size = MediaQuery.of(context).size;

  return SizedBox(
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
            team.middleName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: id >= 13
                    ? const Color.fromRGBO(18, 32, 84, 1)
                    : Colors.white,
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 11)),
          ),
        )
      ],
    ),
  );
}
