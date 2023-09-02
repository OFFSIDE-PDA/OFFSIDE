import 'package:flutter/material.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyTravel extends StatelessWidget {
  const MyTravel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        AppBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            "내 여행일정 확인",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 12)),
          ),
        ),
        SizedBox(
          height: size.height * 0.8,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return MatchBox();
              }),
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

class MatchBox extends StatelessWidget {
  const MatchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // TODO: implement build
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
            offset: const Offset(5, 5), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "2023.08.21",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 12)),
          ),
          Container(
            width: size.width * 0.7,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: Color.fromRGBO(18, 32, 84, 1),
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "19:30",
                    style: TextStyle(
                        color: Color.fromARGB(255, 68, 68, 68),
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12)),
                  ),
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
                                child: Image.asset('/images/KLeague.png')),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              // teamInfoList[team2].middleName,
                              "울산 현대",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 11)),
                            )
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
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Text(' vs ',
                              style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 13))),
                        ),
                        Column(
                          children: [
                            SizedBox(
                                width: size.width * 0.08,
                                height: size.width * 0.08,
                                // child: Image.network(teamInfoList[team2].logoImg),
                                child: Image.asset('/images/KLeague.png')),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              // teamInfoList[team2].middleName,
                              "수원 삼성",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 11)),
                            )
                          ],
                        ),
                      ]),
                ]),
          ),
          //어차피 2개만 보여줄거면 리스트 뷰 필요없이 그냥 2개 띄우는게 편함
          TravelBox(),
          TravelBox(),
          Container(
            width: size.width,
            padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
            child: InkWell(
              onTap: () {},
              // 여행 일정으로 이동
              child: Text(
                "자세히 보기",
                textAlign: TextAlign.right,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 11),
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(18, 32, 84, 1)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TravelBox extends StatelessWidget {
  const TravelBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.lens,
            size: 10,
            color: Color.fromARGB(255, 92, 127, 255),
          ),
          SizedBox(
            width: size.width * 0.05,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "더 노은로",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    "카페",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 11),
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "대전 유성구 노은서로 19-2 1층 더노은로",
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
