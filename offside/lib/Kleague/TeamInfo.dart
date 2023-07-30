import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamInfo extends StatefulWidget {
  const TeamInfo({
    Key? key,
    required this.team,
  }) : super(key: key);

  final int team;

  @override
  State<TeamInfo> createState() => _TeamInfo();
}

class _TeamInfo extends State<TeamInfo> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return (Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NameAndPage(widget.team, context),
            teamInfo(widget.team, context)
          ],
        )));
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();

  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

Widget NameAndPage(int id, BuildContext context) {
  var size = MediaQuery.of(context).size;

  List name = <String>[
    "강원 FC",
    "광주 FC",
    "대구 FC",
    "대전 하나시티즌",
    "FC 서울",
    "수원 삼성 블루윙즈",
    "수원 FC",
    "울산 현대",
    "인천 유나이티드",
    "전북 현대 모터스",
    "제주 유나이티드",
    "포항 스틸러스",
    "경남 FC",
    "김천 상무",
    "김포 FC",
    "부산 아이파크",
    "부천 FC 1995",
    "서울 이랜드",
    "성남 FC",
    "안산 그리너스",
    "FC 안양",
    "전남 드래곤즈",
    "충남 아산 FC",
    "충북 청주 FC",
    "천안 시티 FC"
  ];

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

  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                width: size.width * 0.13,
                height: size.width * 0.13,
                child: teamIcon(id)),
            Text(
              name[id - 1],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(18, 32, 84, 1),
                fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 13),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(sites[id - 1]),
            );
          },
          child: Text(
            "홈페이지 바로가기 >",
            style: TextStyle(
                color: Color.fromRGBO(18, 32, 84, 1),
                fontWeight: FontWeight.bold),
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(
                  color: Color.fromRGBO(18, 32, 84, 1),
                )),
          )),
        )
      ]);
}

Widget teamInfo(int id, BuildContext context) {
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
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
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
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
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
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    ),
  ));
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
