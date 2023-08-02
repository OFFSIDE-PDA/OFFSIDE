import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';

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

    return (ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBar(),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Column(children: [
              NameAndPage(widget.team, context),
              teamInfo(widget.team, context),
              teamPic(widget.team, context),
              Recommended(id: widget.team)
            ]),
          )
        ],
      )
    ]));
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

  List years = <int>[
    2008,
    2010,
    2002,
    1997,
    1983,
    1995,
    2003,
    1983,
    2003,
    1994,
    1982,
    1973,
    2006,
    1984,
    2013,
    1979,
    2007,
    2014,
    1989,
    2017,
    2013,
    1994,
    1996,
    2002,
    2008
  ];

  List city = <String>[
    "강원도 강릉시",
    "광주광역시",
    "대구광역시",
    "대전광역시",
    "서울특별시",
    "경기도 수원특례시",
    "경기도 수원특례시",
    "울산광역시",
    "인천광역시",
    "전라북도 전주시",
    "제주특별자치도",
    "경상북도 포항시",
    "경상남도 창원시",
    "경상북도 김천시",
    "경기도 김포시",
    "부산광역시",
    "경기도 부천시",
    "서울특별시",
    "경기도 성남시",
    "경기도 안산시",
    "경기도 안양시",
    "전라남도 광양시",
    "충청남도 아산시",
    "충청북도 청주시",
    "충청남도 천안시"
  ];

  List stadium = <String>[
    "강릉 종합운동장",
    "광주 축구전용구장",
    "DGB 대구은행 파크",
    "대전 월드컵 경기장",
    "서울 월드컵 경기장",
    "수원 월드컵 경기장",
    "수원 종합운동장",
    "울산 문수 축구경기장",
    "인천 축구전용경기장",
    "전주 월드컵 경기장",
    "제주 월드컵 경기장",
    "포항 스틸야드",
    "창원 축구센터",
    "김천 종합운동장",
    "김포 솔터 축구장",
    "부산 아시아드 주경기장",
    "부천 종합운동장",
    "목동 종합운동장",
    "탄천 중합운동장",
    "안산 와스타디움",
    "안양 종합운동장",
    "광양 축구전용구장",
    "아산 이순신 종합운동장",
    "청주 종합운동장",
    "천안 종합운동장"
  ];

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
            ),
            Text(
              years[id - 1].toString() + "년",
              style: TextStyle(
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
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
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              city[id - 1],
              style: TextStyle(
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
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
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              stadium[id - 1],
              style: TextStyle(
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  fontWeight: FontWeight.normal),
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
          child: Image.asset('images/K2_png/bc.jpg'));
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

Widget teamPic(int id, BuildContext context) {
  var size = MediaQuery.of(context).size;
  switch (id) {
    case 1:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/gangwon.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 2:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/gwangju.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 3:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/daegu.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 4:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/daejeon.jpeg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 5:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/seoul.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 6:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/samsung.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 7:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/suwon.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 8:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/ulsan.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 9:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/incheon.jpeg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 10:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/jeonbuk.png',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 11:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/jeju.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 12:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k1/pohang.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 13:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/kyeongnam.jpeg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 14:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/gimcheon.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 15:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/gimpo.jpeg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 16:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/busan.jpeg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 17:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/bucheon.PNG',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 18:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/seoulE.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 19:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/seongnam.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 20:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/ansan.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 21:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/anyang.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 22:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/jeonnam.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 23:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/asan.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 24:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/cheongju.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    case 25:
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'images/stadium/k2/cheonan.jpg',
          fit: BoxFit.fill,
          width: size.width * 0.9,
          height: size.height * 0.25,
        ), // Text(key['title']),
      );
    default:
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'stadium/k1/gwangju.jpg',
          fit: BoxFit.fill,
        ), // Text(key['title']),
      );
  }
}

class Recommended extends StatefulWidget {
  final id;

  Recommended({
    Key? key,
    required this.id,
  }) : super(key: key);

  // 선택한 팀 정보

  @override
  State<Recommended> createState() => _Recommended();
}

class _Recommended extends State<Recommended> {
  int category = 1;

  void _choose(e) {
    setState(() {
      category = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // widget.id == 팀 선택 정보(1~23)

    return (Container(
      width: size.width,
      padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
      child: (Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("추천 관광지",
              style: TextStyle(
                  fontSize: AdaptiveTextSize().getadaptiveTextSize(context, 13),
                  fontWeight: FontWeight.bold)),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 3, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _choose(1);
                  },
                  child: Text(
                    "관광지",
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
                    ),
                    backgroundColor: category == 1
                        ? MaterialStateProperty.all<Color>(
                            Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                TextButton(
                  onPressed: () {
                    _choose(2);
                  },
                  child: Text(
                    "문화시설",
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
                    ),
                    backgroundColor: category == 2
                        ? MaterialStateProperty.all<Color>(
                            Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                TextButton(
                  onPressed: () {
                    _choose(3);
                  },
                  child: Text(
                    "숙박",
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
                    ),
                    backgroundColor: category == 3
                        ? MaterialStateProperty.all<Color>(
                            Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                TextButton(
                  onPressed: () {
                    _choose(4);
                  },
                  child: Text(
                    "음식점",
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
                    ),
                    backgroundColor: category == 4
                        ? MaterialStateProperty.all<Color>(
                            Color.fromRGBO(214, 223, 255, 1))
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                )
              ],
            ),
          ),
          here(widget.id, category)
        ],
      )),
    ));
  }
}

Widget here(int id, int category) {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int id) {
        var size = MediaQuery.of(context).size;
        return Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      'https://picsum.photos/250?image=9',
                      width: size.width * 0.15,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name Test",
                        style: TextStyle(
                            fontSize: AdaptiveTextSize()
                                .getadaptiveTextSize(context, 13),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Address test",
                        style: TextStyle(
                            fontSize: AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12),
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        );
      });
}
