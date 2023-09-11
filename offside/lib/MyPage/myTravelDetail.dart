import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/TourSchedule/tourPlan.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';

class MyTravelDetail extends ConsumerStatefulWidget {
  const MyTravelDetail({super.key, required this.info, required this.docUid});
  final Map info;
  final String docUid;
  @override
  _MyTravelDetail createState() => _MyTravelDetail();
}

class _MyTravelDetail extends ConsumerState<MyTravelDetail> {
  getDate(date) =>
      '${date[0]}${date[1]}.${date[2]}${date[3]}.${date[4]}${date[5]}';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    final user = ref.read(userViewModelProvider);
    var matchDate = widget.info.keys.first;
    var match = widget.info[matchDate]['match'];
    var tour = widget.info[matchDate]['tour'];
    return ListView(
      children: [
        AppBar(),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text("나의 여행 일정",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 12)))),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text("내가 선택한 경기",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 12)))),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1.5, color: const Color.fromRGBO(18, 32, 84, 1)),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('20${getDate(matchDate)}',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 68, 68, 68),
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.08,
                              height: size.width * 0.08,
                              child: Image.network(
                                  teamInfoList[match['home']].logoImg),
                            ),
                            const SizedBox(width: 7),
                            Text(teamInfoList[match['home']].middleName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 11)))
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Text(' vs ',
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 13)))),
                        Row(children: [
                          SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: Image.network(
                                teamInfoList[match['away']].logoImg),
                          ),
                          const SizedBox(width: 7),
                          Text(teamInfoList[match['away']].middleName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 11)))
                        ])
                      ])
                ])),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text("내가 방문할 곳",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 12)))),
        Container(
            height: tour.length * 80,
            margin: const EdgeInsets.only(top: 15),
            child: ReorderableListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: <Widget>[
                  for (int index = 0; index < tour.length; index += 1)
                    InkWell(
                      key: Key('$index'),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(tour[index]['title'],
                                      style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(
                                                  context, 13))),
                                  content: const SingleChildScrollView(
                                      child: ListBody(children: <Widget>[
                                    Text('해당 일정을 삭제하시겠습니까?')
                                  ])),
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
                                            tour.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(deleteSnackBar);
                                          Navigator.of(context).pop();
                                        })
                                  ]);
                            });
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                              border: Border(top: BorderSide())),
                          child: ListTile(
                              leading: Image.network(tour[index]['img'],
                                  width: size.width * 0.18,
                                  errorBuilder: (context, url, error) => SizedBox(
                                      width: size.width * 0.18,
                                      child: Image.asset(
                                          'images/mainpage/logo.png'))),
                              title: Text('${tour[index]['title']}  ${getType[tour[index]['typeId']]}',
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 12))),
                              subtitle: Text(tour[index]['addr'],
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 12))))),
                    )
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = tour.removeAt(oldIndex);
                    tour.insert(newIndex, item);
                  });
                })),
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('20${getDate(matchDate)}',
                            style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 13))),
                        content: SingleChildScrollView(
                            child: ListBody(children: <Widget>[
                          Text(tour.isNotEmpty
                              ? '여행일정을 수정하시겠습니까?'
                              : '여행일정을 삭제하시겠습니까?')
                        ])),
                        actions: [
                          TextButton(
                              child: const Text('취소'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                              child: const Text('확인'),
                              onPressed: () {
                                tour.isNotEmpty
                                    ? updateTourPlan(
                                            user.user!.uid,
                                            tour,
                                            matchDate,
                                            match['home'],
                                            match['away'],
                                            match['time'],
                                            widget.docUid)
                                        .then((value) =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(saveSnackBar))
                                    : deleteTourPlan(
                                            user.user!.uid, widget.docUid)
                                        .then((value) =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(deleteSnackBar));

                                Navigator.of(context).pop();
                              })
                        ]);
                  });
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), //<-- SEE HERE
                padding: const EdgeInsets.all(20),
                backgroundColor: const Color.fromRGBO(33, 58, 135, 1)),
            child: const Icon(Icons.check, color: Colors.white))
      ],
    );
  }
}

final deleteSnackBar = SnackBar(
    content: const Text('여행 일정이 삭제되었습니다'),
    action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // Some code to undo the change.
        }));

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}
