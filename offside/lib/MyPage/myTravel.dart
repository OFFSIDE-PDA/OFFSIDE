import 'package:flutter/material.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyTravel extends ConsumerStatefulWidget {
  const MyTravel({super.key});
  @override
  _MyTravel createState() => _MyTravel();
}

class _MyTravel extends ConsumerState<MyTravel> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final user = ref.read(userViewModelProvider);
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;

    return FutureBuilder(
        future: user.getMyTour(uid: user.user!.uid),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List info = snapshot.data!;
            return ListView(children: [
              AppBar(),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text("내 여행일정 확인",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12)))),
              SizedBox(
                  height: size.height * 0.8,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: info.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MatchBox(
                            info: info[index], teamInfo: teamInfoList);
                      }))
            ]);
          } else if (snapshot.hasError) {
            return const Center(child: Text('error'));
          }
          return const Text('No data');
        }));
  }
}

class MatchBox extends StatelessWidget {
  const MatchBox({Key? key, required this.info, required this.teamInfo})
      : super(key: key);
  final Map info;
  final List<TeamInfo> teamInfo;

  getDate(date) =>
      '${date[0]}${date[1]}.${date[2]}${date[3]}.${date[4]}${date[5]}';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var matchDate = info.keys.first;

    return Container(
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
                  offset: const Offset(5, 5) // changes position of shadow
                  )
            ]),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('20${getDate(matchDate)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 12))),
              Container(
                  width: size.width * 0.7,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5,
                          color: const Color.fromRGBO(18, 32, 84, 1)),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(info[matchDate]['match']['time'],
                            style: TextStyle(
                                color: const Color.fromARGB(255, 68, 68, 68),
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 12))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                      width: size.width * 0.08,
                                      height: size.width * 0.08,
                                      // child: Image.network(teamInfoList[team2].logoImg),
                                      child: Image.network(teamInfo[
                                              info[matchDate]['match']['home']]
                                          .logoImg)),
                                  const SizedBox(height: 7),
                                  Text(
                                      teamInfo[info[matchDate]['match']['home']]
                                          .middleName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(
                                                  context, 11)))
                                ],
                              ),

                              // getScore(info.first.data)
                              //     ? Text(
                              //         ' ${info[index].score1} : ${info[index].score2} ',
                              //         style: TextStyle(
                              //             fontSize: const AdaptiveTextSize()
                              //                 .getadaptiveTextSize(
                              //                     context, 13)))
                              //     :
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(' vs ',
                                      style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(
                                                  context, 13)))),
                              Column(children: [
                                SizedBox(
                                    width: size.width * 0.08,
                                    height: size.width * 0.08,
                                    // child: Image.network(teamInfoList[team2].logoImg),
                                    child: Image.network(teamInfo[
                                            info[matchDate]['match']['away']]
                                        .logoImg)),
                                const SizedBox(height: 7),
                                Text(
                                    teamInfo[info[matchDate]['match']['away']]
                                        .middleName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 11)))
                              ])
                            ])
                      ])),
              //어차피 2개만 보여줄거면 리스트 뷰 필요없이 그냥 2개 띄우는게 편함
              info[matchDate]['tour'].length > 1
                  ? Column(children: [
                      TravelBox(tour: info[matchDate]['tour'][0]),
                      TravelBox(tour: info[matchDate]['tour'][1]),
                    ])
                  : TravelBox(tour: info[matchDate]['tour'][0]),

              Container(
                  width: size.width,
                  padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                  child: InkWell(
                      onTap: () {},
                      // 여행 일정으로 이동
                      child: Text("자세히 보기",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 11),
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(18, 32, 84, 1)))))
            ]));
  }
}

class TravelBox extends StatelessWidget {
  const TravelBox({Key? key, required this.tour}) : super(key: key);

  final Map tour;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.lens,
              size: 10, color: Color.fromARGB(255, 92, 127, 255)),
          SizedBox(width: size.width * 0.05),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(tour['title'],
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12),
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: size.width * 0.02),
                  Text(getType[tour['typeId']]!,
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 11),
                          fontWeight: FontWeight.w500,
                          color: Colors.grey))
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                tour['addr'],
                style: TextStyle(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 11),
                    fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      )),
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
