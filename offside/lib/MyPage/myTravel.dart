import 'package:flutter/material.dart';
import 'package:offside/Match/match.dart';
import 'package:offside/MyPage/myTravelDetail.dart';
import 'package:offside/TourSchedule/tourSchedule.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/model/tour_model.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/page_view_model.dart';

class MyTravel extends ConsumerStatefulWidget {
  const MyTravel({super.key});
  @override
  _MyTravel createState() => _MyTravel();
}

class _MyTravel extends ConsumerState<MyTravel> {
  getDate(date) =>
      '${date[1]}${date[2]}.${date[3]}${date[4]}.${date[5]}${date[6]}';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final user = ref.read(userViewModelProvider);
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;

    return ListView(
      children: [
        AppBar(),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("내 여행일정 확인",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12))),
                Text("(길게 눌러서 삭제)",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 10))),
              ],
            )),
        FutureBuilder(
            future: user.getMyTour(uid: user.user!.uid),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                Map info = snapshot.data!;
                return info.isNotEmpty
                    ? SizedBox(
                        height: size.height * 0.8,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: info.keys.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onDoubleTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: Text(
                                                '20${getDate(info[info.keys.elementAt(index)].keys.toString())}',
                                                style: TextStyle(
                                                    fontSize:
                                                        const AdaptiveTextSize()
                                                            .getadaptiveTextSize(
                                                                context, 12))),
                                            content:
                                                const Text('여행일정을 삭제하시겠습니까?'),
                                            actions: [
                                              TextButton(
                                                  child: const Text('취소'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                              TextButton(
                                                  child: const Text('확인'),
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteTourPlan(
                                                              user.user!.uid,
                                                              info.keys
                                                                  .elementAt(
                                                                      index))
                                                          .then((value) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                deleteSnackBar);
                                                      });
                                                    });
                                                  })
                                            ]);
                                      });
                                },
                                child: MatchBox(
                                    info: info[info.keys.elementAt(index)],
                                    teamInfo: teamInfoList,
                                    docUid: info.keys.elementAt(index)),
                              );
                            }))
                    : Center(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  'assets/images/mainpage/logo.png',
                                  height: 50,
                                  width: double.maxFinite,
                                )),
                            const Text(
                              "아직 여행 계획이 없으신가요?\nOFFSIDE와 함께 여행 계획해요",
                              textAlign: TextAlign.center,
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: const Color.fromRGBO(18, 32, 84, 1)),
                                child: InkWell(
                                    onTap: () async {
                                      ref
                                          .read(counterPageProvider.notifier)
                                          .update((state) => [1, 0]);
                                      Navigator.pop(context);
                                    },
                                    // 여행 일정으로 이동
                                    child: Text("여행 계획 하기",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: const AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 11),
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white))))
                          ],
                        ),
                      );
              } else if (snapshot.hasError) {
                return const Center(child: Text('error'));
              }
              return const Center(child: Text('No data'));
            })),
      ],
    );
  }
}

class MatchBox extends StatelessWidget {
  const MatchBox(
      {Key? key,
      required this.info,
      required this.teamInfo,
      required this.docUid})
      : super(key: key);
  final Map info;
  final List<TeamInfo> teamInfo;
  final String docUid;

  getDate(date) =>
      '${date[0]}${date[1]}.${date[2]}${date[3]}.${date[4]}${date[5]}';

  String convertTime(date) {
    var tmp = int.parse(date[0] + date[1]);
    var returnString = '';
    if (tmp < 12) {
      returnString = (tmp + 12).toString();
    }
    return "$returnString:${date[2]}${date[3]}";
  }

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
                      fontWeight: FontWeight.w500,
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
                        Text(convertTime(info[matchDate]['match']['time']),
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
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyTravelDetail(
                                    info: info, docUid: docUid)));
                      },
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
                    const SizedBox(height: 4),
                    Text(tour['addr'],
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 11),
                            fontWeight: FontWeight.w500))
                  ])
            ])));
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}
