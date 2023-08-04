import 'package:offside/data/model/team_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'TeamInfo.dart';

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

class KLeagueOne extends StatelessWidget {
  const KLeagueOne({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      color: const Color.fromRGBO(18, 32, 84, 1),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Text(
                "K 리그 1",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
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
                    team(1, context, teamK1[0]),
                    team(2, context, teamK1[1]),
                    team(3, context, teamK1[2]),
                    team(4, context, teamK1[3])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(5, context, teamK1[4]),
                    team(6, context, teamK1[5]),
                    team(7, context, teamK1[6]),
                    team(8, context, teamK1[7])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(9, context, teamK1[8]),
                    team(10, context, teamK1[9]),
                    team(11, context, teamK1[10]),
                    team(12, context, teamK1[11])
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

class KLeagueTwo extends StatelessWidget {
  const KLeagueTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 570,
      alignment: Alignment.topLeft,
      child: Column(children: [
        Container(
          alignment: Alignment.topLeft,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
            child: Text(
              "K 리그 2",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
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
                  team(13, context, teamK2[0]),
                  team(14, context, teamK2[1]),
                  team(15, context, teamK2[2]),
                  team(16, context, teamK2[3])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  team(17, context, teamK2[4]),
                  team(18, context, teamK2[5]),
                  team(19, context, teamK2[6]),
                  team(20, context, teamK2[7])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  team(21, context, teamK2[8]),
                  team(22, context, teamK2[9]),
                  team(23, context, teamK2[10]),
                  team(24, context, teamK2[11])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  team(25, context, teamK2[12]),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}

Widget team(int id, BuildContext context, name) {
  var size = MediaQuery.of(context).size;

  String getName(String selectedTeam) {
    return selectedTeam.replaceAll('\n', ' ');
  }

  return SizedBox(
    height: 120,
    child: Column(
      children: [
        InkWell(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeamInfo(team: getName(name))));
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
            child: Image.asset(teamTransfer[getName(name)]['img']),
          ),
        ),
        SizedBox(
          width: 80,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: id >= 13
                    ? const Color.fromRGBO(18, 32, 84, 1)
                    : Colors.white,
                fontSize: 14),
          ),
        )
      ],
    ),
  );
}
