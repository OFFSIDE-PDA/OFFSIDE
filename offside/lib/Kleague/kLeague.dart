import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OFFSIDE",
      routes: {
        "/": (context) => KLeague(),
      },
    );
  }
}

class KLeague extends StatelessWidget {
  const KLeague({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        SizedBox(
          child: Top(),
        ),
        Container(
          height: 450,
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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/mark2.png'))),
    );
  }
}

class KLeagueOne extends StatelessWidget {
  List name = <String>[
    "강원 FC",
    "광주 FC",
    "대구 FC",
    "대전\n하나 시티즌",
    "FC 서울",
    "수원 삼성\n블루윙즈",
    "수원 FC",
    "울산 현대",
    "인천\n유나이티드",
    "전북 현대\n모터스",
    "제주\n유나이티드",
    "포항\n스틸러스"
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      color: Color.fromRGBO(18, 32, 84, 1),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      team(1, context, name[0]),
                      team(2, context, name[1]),
                      team(3, context, name[2]),
                      team(4, context, name[3])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      team(5, context, name[4]),
                      team(6, context, name[5]),
                      team(7, context, name[6]),
                      team(8, context, name[7])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      team(9, context, name[8]),
                      team(10, context, name[9]),
                      team(11, context, name[10]),
                      team(12, context, name[11])
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KLeagueTwo extends StatelessWidget {
  List name = <String>[
    "경남 FC",
    "김천 상무",
    "김포 FC",
    "부산\n아이파크",
    "부천 FC\n1995",
    "서울 이랜드",
    "성남 FC",
    "안산\n그리너스",
    "FC 안양",
    "전남\n드래곤즈",
    "충남\n아산 FC",
    "충북\n청주 FC",
    "천안\n시티 FC"
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(18, 32, 84, 1)),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(13, context, name[0]),
                    team(14, context, name[1]),
                    team(15, context, name[2]),
                    team(16, context, name[3])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(17, context, name[4]),
                    team(18, context, name[5]),
                    team(19, context, name[6]),
                    team(20, context, name[7])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(21, context, name[8]),
                    team(22, context, name[9]),
                    team(23, context, name[10]),
                    team(24, context, name[11])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    team(25, context, name[12]),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

Widget team(int id, BuildContext context, name) {
  var size = MediaQuery.of(context).size;

  List sites = <String>[
    "https://www.gangwon-fc.com/",
    "https://www.gwangjufc.com/",
    "https://daegufc.co.kr/main/",
    "https://www.dhcfc.kr/",
    "https://m.fcseoul.com/",
    "http://www.bluewings.kr/",
    "https://www.suwonfc.com/",
    "https://www.uhfc.tv/",
    "https://www.incheonutd.com/main/index.php",
    "https://hyundai-motorsfc.com/",
    "https://www.jeju-utd.com/",
    "https://www.steelers.co.kr/",
    "https://www.gyeongnamfc.com/",
    "https://www.gimcheonfc.com/index.php",
    "https://www.gimpofc.co.kr/",
    "https://www.busanipark.com/",
    "http://bfc1995.com/site/main/index112",
    "https://www.seoulelandfc.com/",
    "https://shopsfc.com/",
    "https://www.greenersfc.com/",
    "https://www.fc-anyang.com/",
    "https://www.dragons.co.kr/",
    "https://www.asanfc.com/index.php",
    "http://chfc.kr/",
    "https://cheonancityfc.kr/"
  ];

  return Container(
    height: 120,
    child: Column(
      children: [
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse(sites[id - 1]),
            );
          },
          child: Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            width: size.width * 0.13,
            height: size.width * 0.13,
            decoration: BoxDecoration(
                color: id >= 13 ? Color.fromRGBO(18, 32, 84, 1) : Colors.white,
                borderRadius: BorderRadius.circular(100)),
            child: teamIcon(id),
          ),
        ),
        Container(
          width: 80,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: id >= 13 ? Color.fromRGBO(18, 32, 84, 1) : Colors.white,
                fontSize: 14),
          ),
        )
      ],
    ),
  );
}

Widget teamIcon(int id) {
  switch (id) {
    case 1:
      return SvgPicture.asset('icons/kOne/Gangwon.svg');
    case 2:
      return SvgPicture.asset('icons/kOne/GwangJu.svg');
    case 3:
      return SvgPicture.asset('icons/kOne/Daegu.svg');
    case 4:
      return SvgPicture.asset('icons/kOne/Daejeon.svg');
    case 5:
      return SvgPicture.asset('icons/kOne/Seoul.svg');
    case 6:
      return SvgPicture.asset('icons/kOne/suwon.svg');
    case 7:
      return SvgPicture.asset('icons/kOne/suwonFC.svg');
    case 8:
      return SvgPicture.asset('icons/kOne/ulsan.svg');
    case 9:
      return SvgPicture.asset('icons/kOne/incheon.svg');
    case 10:
      return SvgPicture.asset('icons/kOne/jeonbuk.svg');
    case 11:
      return SvgPicture.asset('icons/kOne/jeju.svg');
    case 12:
      return SvgPicture.asset('icons/kOne/pohang.svg');
    case 13:
      return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset('images/kn.png'));
    case 14:
      return SvgPicture.asset('icons/kTwo/kimcheon.svg');
    case 15:
      return SvgPicture.asset('icons/kTwo/kimpo.svg');
    case 16:
      return SvgPicture.asset('icons/kTwo/busan.svg');
    case 17:
      return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset('images/bc.jpg'));
    case 18:
      return SvgPicture.asset('icons/kTwo/seoulE.svg');
    case 19:
      return SvgPicture.asset('icons/kTwo/seongnam.svg');
    case 20:
      return SvgPicture.asset('icons/kTwo/ansan.svg');
    case 21:
      return SvgPicture.asset('icons/kTwo/anyang.svg');
    case 22:
      return SvgPicture.asset('icons/kTwo/jeonnam.svg');
    case 23:
      return SvgPicture.asset('icons/kTwo/asan.svg');
    case 24:
      return SvgPicture.asset('icons/kTwo/chungju.svg');
    case 25:
      return SvgPicture.asset('icons/kTwo/cheonan.svg');

    default:
      return SvgPicture.asset('icons/kTwo/cheonan.svg');
  }
}
