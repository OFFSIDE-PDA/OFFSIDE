import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/MainPage/home_page.dart';
import 'package:offside/MyPage/myTravel.dart';
import 'package:offside/MyPage/mypage.dart';
import 'package:offside/TourSchedule/first.dart';
import 'package:offside/TourSchedule/second.dart';
import 'package:offside/TourSchedule/third.dart';
import 'package:offside/data/api/map_api.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:offside/TourSchedule/tourSchedule.dart';

List selectedList = [];

class TourPlan extends ConsumerStatefulWidget {
  const TourPlan(
      {super.key,
      required this.home,
      required this.away,
      required this.date,
      required this.time});
  final int home;
  final int away;
  final String date;
  final String time;
  @override
  _TourPlan createState() => _TourPlan();
}

class _TourPlan extends ConsumerState<TourPlan> {
  int step = 1;
  late Future<List> points;
  var starty = 36.6284028, startx = 127.4592136;
  var idx = 0;
  bool flag = false;

  getDate(date) =>
      '${date[0]}${date[1]}.${date[2]}${date[3]}.${date[4]}${date[5]}';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    final user = ref.watch(userViewModelProvider);
    var uid = user.user!.uid;
    final double statusBarSize = MediaQuery.of(context).padding.top;
    points = getRoute(
        startx,
        starty,
        teamInfoList[widget.home].stadiumGeo.longitude,
        teamInfoList[widget.home].stadiumGeo.latitude);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          // AppBar(),
          SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, statusBarSize, 20, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 3.0),
                        child: Icon(Icons.card_travel,
                            size: 22, color: Color.fromRGBO(91, 143, 255, 1))),
                    SizedBox(width: size.width * 0.01),
                    Text('My Travel',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14),
                            color: const Color.fromRGBO(33, 58, 135, 1))),
                  ],
                )),
          ),
          SizedBox(height: size.height * 0.015),
          PlanStep(size: size, step: step),
          SizedBox(height: size.height * 0.025),
          returnStep(step, size, teamInfoList, uid),
        ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(fit: StackFit.expand, children: [
          Positioned(
              left: 25,
              bottom: 15,
              child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (step == 1) {
                        selectedList.clear();
                        Navigator.pop(context);
                      } else {
                        step -= 1;
                      }
                    });
                  },
                  backgroundColor:
                      const Color.fromRGBO(33, 58, 135, 1), // <-- Button color
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 25))),
          Positioned(
              bottom: 15,
              right: 25,
              child: FloatingActionButton(
                  onPressed: () async {
                    setState(() {
                      if (step == 3) {
                        if (selectedList.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    title: Text('20${getDate(widget.date)}'),
                                    content: const SingleChildScrollView(
                                        child: ListBody(children: <Widget>[
                                      Text('여행일정을 저장하시겠습니까?')
                                    ])),
                                    actions: [
                                      TextButton(
                                          child: const Text('취소'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                      TextButton(
                                          child: const Text('확인'),
                                          onPressed: () async {
                                            await createTourPlan(
                                                    uid,
                                                    selectedList,
                                                    widget.date,
                                                    widget.home,
                                                    widget.away,
                                                    widget.time)
                                                .then((value) {
                                              selectedList.clear();
                                              Navigator.of(context).pop();
                                            });
                                          })
                                    ]);
                              }).then((value) => Navigator.of(context).pop());
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(emptySnackBar);
                        }
                      } else {
                        step += 1;
                      }
                    });
                  },
                  backgroundColor:
                      const Color.fromRGBO(33, 58, 135, 1), // <-- Button color
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: step == 3
                      ? const Icon(Icons.check, color: Colors.white, size: 25)
                      : const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 25)))
        ]));
  }

  returnStep(int step, Size size, List<TeamInfo> teamInfoList, String? uid) {
    var size = MediaQuery.of(context).size;
    if (step == 1) {
      return Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetLocation(context: context, title: 'NOW', text: '현위치'),
              const Icon(
                Icons.arrow_right_alt,
                color: Color.fromRGBO(110, 110, 110, 1),
                size: 25,
              ),
              GetLocation(
                  context: context,
                  title: 'STADIUM',
                  text: teamInfoList[widget.home].stadium)
            ]),
        FutureBuilder<List>(
          future: points,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              List info = snapshot.data!;
              return Container(
                  width: size.width,
                  height: size.width,
                  padding: const EdgeInsets.all(20),
                  child: KakaoMapView(
                    width: size.width,
                    height: size.width,
                    kakaoMapKey: 'a8bd91fccbb230b5011148456b3cd404',
                    zoomLevel: 10,
                    lat: info[0]['y'],
                    lng: info[0]['x'],
                    mapController: (controller) {},
                    customScript: '''
    var markers = [];

    function addMarker(position) {
      var marker = new kakao.maps.Marker({position: position});
      marker.setMap(map);
      markers.push(marker);
    }

    addMarker(new kakao.maps.LatLng(${info.first['y']}, ${info.first['x']}));
    addMarker(new kakao.maps.LatLng(${info.last['y']}, ${info.last['x']}));


    var linePath = [];
    $info.map((item) => {
      linePath.push(new kakao.maps.LatLng(item.y, item.x));
    });

    const polyline = new kakao.maps.Polyline({
        map: map,
        path: linePath,
        strokeWeight: 3, 
        strokeColor: '#0e2057',
        strokeOpacity: 0.7, 
        strokeStyle: 'solid' 
      });
      polyline.setMap(map); 
              ''',
                  ));
            } else if (snapshot.hasError) {
              return const Text('error');
            }
            return Container(
                width: size.width,
                height: size.width,
                padding: const EdgeInsets.all(20),
                child: const Center(child: CupertinoActivityIndicator()));
          }),
        )
      ]);
    } else if (step == 2) {
      return ChooseCategory(
          context: context,
          size: size,
          home: teamInfoList[widget.home].fullName,
          lat: teamInfoList[widget.home].stadiumGeo.latitude,
          lng: teamInfoList[widget.home].stadiumGeo.longitude,
          starty: starty,
          startx: startx);
    } else {
      return Column(children: [
        MatchDate(
            size: size,
            date: widget.date,
            home: widget.home,
            away: widget.away,
            info: teamInfoList),
        TourList(size: size)
      ]);
    }
  }
}

class PlanStep extends StatelessWidget {
  const PlanStep({super.key, required this.size, required this.step});
  final Size size;
  final int step;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Step(step: step, num: 1, text: '지도 확인'),
              const Icon(
                Icons.more_horiz,
                color: Color.fromRGBO(14, 32, 87, 1),
                size: 23,
              ),
              Step(step: step, num: 2, text: '방문지 선택'),
              const Icon(Icons.more_horiz,
                  color: Color.fromRGBO(14, 32, 87, 1), size: 23),
              Step(step: step, num: 3, text: '일정 확인')
            ]));
  }
}

class Step extends StatelessWidget {
  const Step(
      {super.key, required this.step, required this.num, required this.text});
  final int step;
  final int num;
  final String text;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          width: size.width * 0.1,
          height: size.width * 0.1,
          alignment: Alignment.center,
          decoration: step == num ? selectedBox() : unSelectedBox(),
          child: Text('$num',
              style:
                  step == num ? selectedNum(context) : unSelectedNum(context))),
      const SizedBox(height: 10),
      Text(text,
          style: step == num ? selectedText(context) : unSelectedText(context))
    ]);
  }
}

final emptySnackBar = SnackBar(
    content: const Text('여행 일정이 없습니다'),
    action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // Some code to undo the change.
        }));

final saveSnackBar = SnackBar(
    content: const Text('여행 일정이 저장되었습니다'),
    action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // Some code to undo the change.
        }));

BoxDecoration selectedBox() {
  return BoxDecoration(
      color: const Color.fromRGBO(14, 32, 87, 1),
      borderRadius: BorderRadius.circular(10));
}

BoxDecoration unSelectedBox() {
  return BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(14, 32, 87, 1), width: 2),
      borderRadius: BorderRadius.circular(10));
}

TextStyle selectedNum(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 15),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle unSelectedNum(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 15),
    fontWeight: FontWeight.w600,
    color: const Color.fromRGBO(14, 32, 87, 1),
  );
}

TextStyle selectedText(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 12),
    fontWeight: FontWeight.w600,
  );
}

TextStyle unSelectedText(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 12),
    fontWeight: FontWeight.w500,
  );
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}
