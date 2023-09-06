import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamInfoPage extends ConsumerStatefulWidget {
  const TeamInfoPage({
    Key? key,
    required this.team,
  }) : super(key: key);

  final TeamInfo team;
  @override
  createState() => _TeamInfo();
}

class _TeamInfo extends ConsumerState<TeamInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBar(),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Column(children: [
              nameAndPage(widget.team, context),
              teamInfo(widget.team, context),
              teamPic(widget.team, context),
              Recommended(
                  lat: widget.team.stadiumGeo.latitude,
                  lng: widget.team.stadiumGeo.longitude)
            ]),
          )
        ],
      )
    ]);
  }
}

class Recommended extends StatefulWidget {
  const Recommended({Key? key, required this.lat, required this.lng})
      : super(key: key);
  final double lat;
  final double lng;
  @override
  State<Recommended> createState() => _Recommended();
}

class _Recommended extends State<Recommended> {
  int category = 12;

  void _choose(e) {
    setState(() {
      category = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // widget.id == 팀 선택 정보(1~23)
    return Container(
      width: size.width,
      padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
      child: (Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("추천 관광지",
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 13),
                  fontWeight: FontWeight.bold)),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 3, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _choose(12);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 12
                        ? MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    "관광지",
                    style: TextStyle(
                        color: Color.fromRGBO(18, 32, 84, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                TextButton(
                  onPressed: () {
                    _choose(14);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 14
                        ? MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    "문화시설",
                    style: TextStyle(
                        color: Color.fromRGBO(18, 32, 84, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                TextButton(
                  onPressed: () {
                    _choose(32);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 32
                        ? MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    "숙박",
                    style: TextStyle(
                        color: Color.fromRGBO(18, 32, 84, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                TextButton(
                  onPressed: () {
                    _choose(39);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 39
                        ? MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    "음식점",
                    style: TextStyle(
                        color: Color.fromRGBO(18, 32, 84, 1),
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          PlaceList(category: category, lat: widget.lat, lng: widget.lng)
        ],
      )),
    );
  }
}

class PlaceList extends StatefulWidget {
  const PlaceList(
      {super.key,
      required this.category,
      required this.lat,
      required this.lng});

  final int category;
  final double lat;
  final double lng;

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  late Future<List<TourModel>> futureTourData;

  @override
  void initState() {
    super.initState();
    futureTourData = getTourData(widget.lat, widget.lng, widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TourModel>>(
        future: futureTourData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TourModel> info = snapshot.data!;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: (info.length / 2).floor(),
                itemBuilder: (BuildContext context, int index) {
                  var size = MediaQuery.of(context).size;
                  return Column(children: [
                    Container(
                        width: size.width,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(info[index].img,
                                      width: size.width * 0.15,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, url, error) =>
                                          SizedBox(
                                              width: size.width * 0.15,
                                              child: Image.asset(
                                                  'images/mainpage/logo.png')))),
                              SizedBox(width: size.width * 0.05),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: size.width * 0.65,
                                        child: Flexible(
                                            child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                    text: info[index].title,
                                                    style: TextStyle(
                                                        fontSize:
                                                            const AdaptiveTextSize()
                                                                .getadaptiveTextSize(
                                                                    context,
                                                                    13),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            Colors.black))))),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                        width: size.width * 0.65,
                                        child: Flexible(
                                            child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                    text: info[index].addr,
                                                    style: TextStyle(
                                                        fontSize:
                                                            const AdaptiveTextSize()
                                                                .getadaptiveTextSize(
                                                                    context,
                                                                    11),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: const Color
                                                                .fromARGB(255,
                                                            67, 67, 67))))))
                                  ])
                            ])),
                    const Divider(thickness: 1, color: Colors.grey)
                  ]);
                });
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('error'));
          }
          return const Center(child: CupertinoActivityIndicator());
        });
  }
}

Widget teamInfo(dynamic team, BuildContext context) {
  var size = MediaQuery.of(context).size;
  return (Container(
      margin:
          EdgeInsets.fromLTRB(15, size.height * 0.02, 15, size.height * 0.02),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("창단년도 : ",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12),
                        fontWeight: FontWeight.bold)),
                Text("${team.founded.toDate().year}년",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12),
                        fontWeight: FontWeight.normal))
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("연고지 : ",
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12),
                          fontWeight: FontWeight.bold)),
                  Text(team.city,
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12),
                          fontWeight: FontWeight.normal))
                ]),
            SizedBox(height: size.height * 0.01),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("홈 경기장 : ",
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12),
                          fontWeight: FontWeight.bold)),
                  Text(team.stadium,
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12),
                          fontWeight: FontWeight.normal))
                ])
          ])));
}

Widget teamPic(dynamic team, BuildContext context) {
  var size = MediaQuery.of(context).size;
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: Image.network(
      team.stadiumImg,
      fit: BoxFit.fill,
      width: size.width * 0.9,
      height: size.height * 0.25,
    ),
  );
}

Widget nameAndPage(dynamic team, BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                width: size.width * 0.13,
                height: size.width * 0.13,
                child: Image.network(team.logoImg)),
            Text(
              team.fullName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(18, 32, 84, 1),
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 13),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(team.site),
            );
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(
                  color: Color.fromRGBO(18, 32, 84, 1),
                )),
          )),
          child: const Text(
            "홈페이지 바로가기 >",
            style: TextStyle(
                color: Color.fromRGBO(18, 32, 84, 1),
                fontWeight: FontWeight.bold),
          ),
        )
      ]);
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}
