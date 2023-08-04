import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:offside/data/view/tour_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class TeamInfo extends ConsumerStatefulWidget {
  const TeamInfo({
    Key? key,
    required this.team,
  }) : super(key: key);

  final String team;

  @override
  createState() => _TeamInfo();
}

class _TeamInfo extends ConsumerState<TeamInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tourData = ref.read(tourViewModelProvider);
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
                  name: widget.team, info: tourData.getTourInfo(widget.team))
            ]),
          )
        ],
      )
    ]);
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

Widget nameAndPage(String name, BuildContext context) {
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
                child: Image.asset(teamTransfer[name]['img'])),
            Text(
              name,
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
              Uri.parse(teamTransfer[name]['site']),
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

Widget teamInfo(String name, BuildContext context) {
  var size = MediaQuery.of(context).size;
  return (Container(
    margin: EdgeInsets.fromLTRB(15, size.height * 0.02, 15, size.height * 0.02),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "창단년도 : ",
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${teamTransfer[name]['year']}년",
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "연고지 : ",
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              teamTransfer[name]['city'],
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "홈 경기장 : ",
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              teamTransfer[name]['stadium'],
              style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.normal),
            )
          ],
        )
      ],
    ),
  ));
}

Widget teamPic(String name, BuildContext context) {
  var size = MediaQuery.of(context).size;
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: Image.asset(
      teamTransfer[name]['stadium_img'],
      fit: BoxFit.fill,
      width: size.width * 0.9,
      height: size.height * 0.25,
    ),
  );
}

class Recommended extends StatefulWidget {
  const Recommended({
    Key? key,
    required this.name,
    required this.info,
  }) : super(key: key);

  final String name; // 선택한 팀 정보
  final Map<String, dynamic> info;
  @override
  State<Recommended> createState() => _Recommended();
}

class _Recommended extends State<Recommended> {
  String category = 'tour';

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
                    _choose('tour');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 'tour'
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
                    _choose('culture');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 'culture'
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
                    _choose('hotel');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 'hotel'
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
                    _choose('food');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(18, 32, 84, 1),
                          )),
                    ),
                    backgroundColor: category == 'food'
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
          here(widget.name, widget.info[category])
        ],
      )),
    );
  }
}

Widget here(String name, var info) {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: info.length,
      itemBuilder: (BuildContext context, int idx) {
        var size = MediaQuery.of(context).size;
        return Column(
          children: [
            Container(
              width: size.width,
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(info[idx].img,
                        width: size.width * 0.15,
                        fit: BoxFit.fill,
                        errorBuilder: (context, url, error) => SizedBox(
                            width: size.width * 0.15,
                            child: Image.asset('images/mainpage/logo.png'))),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.65,
                        child: Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            text: TextSpan(
                              text: info[idx].title,
                              style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 13),
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: size.width * 0.65,
                        child: Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            text: TextSpan(
                              text: info[idx].addr,
                              style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 11),
                                fontWeight: FontWeight.normal,
                                color: const Color.fromARGB(255, 67, 67, 67),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        );
      });
}
