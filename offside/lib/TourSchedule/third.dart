import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offside/TourSchedule/tourPlan.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchDate extends StatelessWidget {
  MatchDate(
      {super.key,
      required this.size,
      required this.date,
      required this.home,
      required this.away,
      required this.info});

  final Size size;
  final String date;
  final int home;
  final int away;
  final List<TeamInfo> info;

  late Future<List> duration;

  getDate(date) =>
      '${date[0]}${date[1]}.${date[2]}${date[3]}.${date[4]}${date[5]}';

  static const String apiUrl =
      "https://apis-navi.kakaomobility.com/v1/waypoints/directions";
  static const String restApiKey =
      "9b39d69c59df2f93e51f3dd3754b7b9c"; // Replace with your Kakao API Key

  Future<List> sendPostRequest() async {
    var wayPoints = [];
    for (var item in selectedList) {
      wayPoints.add({"name": item.title, "x": item.mapx, "y": item.mapy});
    }
    List result = [];
    for (var item in [1, 3, 7]) {
      final Map<String, dynamic> requestData = {
        "origin": {"x": "127.11024293202674", "y": "37.394348634049784"},
        "destination": {
          "x": info[home].stadiumGeo.longitude,
          "y": info[home].stadiumGeo.latitude
        },
        "waypoints": wayPoints,
        "priority": "RECOMMEND",
        "car_type": item
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "KakaoAK $restApiKey",
        },
        body: json.encode(requestData),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int hour = data["routes"][0]["summary"]["duration"] / 60;
        int min = data["routes"][0]["summary"]["duration"] % 60;
        if (hour == 0) {
          result.add("$min분");
        } else {
          result.add("$hour시간 $min분");
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    duration = sendPostRequest();
    return Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01, horizontal: size.width * 0.035),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 48, 84, 190), width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(
                      '20${getDate(date)}',
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12),
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 83, 83, 83)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      info[home].stadium,
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 11),
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 121, 121, 121)),
                    )
                  ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: size.width * 0.08,
                                height: size.width * 0.08,
                                child: Image.network(info[home].logoImg)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(info[home].middleName,
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 12),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Text(' vs ',
                            style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 14),
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 15),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: size.width * 0.08,
                                  height: size.width * 0.08,
                                  child: Image.network(info[away].logoImg)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(info[away].middleName,
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 12),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center)
                            ])
                      ])
                ])),
        FutureBuilder<List>(
          future: duration,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List info = snapshot.data!;
              return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.07,
                      vertical: size.width * 0.07),
                  child: Row(children: [
                    const Text("예상 소요시간"),
                    const SizedBox(width: 10),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(14, 32, 87, 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Row(
                                children: [
                                  Icon(Icons.directions_car,
                                      color: Colors.white),
                                  Text("자동차",
                                      style: TextStyle(color: Colors.white))
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(info[0]))
                        ]))
                  ]));
            } else if (snapshot.hasError) {
              return const Text('error');
            }
            return const Text('No data');
          },
        ),
      ],
    );
  }
}

class TourList extends StatefulWidget {
  const TourList({super.key, required this.size});
  final Size size;

  @override
  State<TourList> createState() => _TourList();
}

class _TourList extends State<TourList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: selectedList.length * 80,
        margin: const EdgeInsets.only(top: 15),
        child: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            children: <Widget>[
              for (int index = 0; index < selectedList.length; index += 1)
                InkWell(
                  key: Key('$index'),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text(selectedList[index].title,
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 13),
                                      fontWeight: FontWeight.w600)),
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
                                        selectedList.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    })
                              ]);
                        });
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 207, 207, 207)))),
                      child: ListTile(
                          trailing: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(selectedList[index].img,
                                width: widget.size.width * 0.18,
                                errorBuilder: (context, url, error) => SizedBox(
                                    width: widget.size.width * 0.18,
                                    child: Image.asset(
                                        'assets/images/mainpage/logo.png'))),
                          ),
                          title: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 4, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${selectedList[index].title}',
                                    style: TextStyle(
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 12),
                                        fontWeight: FontWeight.w600)),
                                Text('${getType[selectedList[index].typeId]}',
                                    style: TextStyle(
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 11),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                              ],
                            ),
                          ),
                          subtitle: Text(selectedList[index].addr,
                              style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)))),
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = selectedList.removeAt(oldIndex);
                selectedList.insert(newIndex, item);
              });
            }));
  }
}
