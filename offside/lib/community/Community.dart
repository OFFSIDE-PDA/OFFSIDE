import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../Kleague/kLeague.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:intl/intl.dart';

import 'ChatData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OFFSIDE",
      routes: {"/": (context) => Community()},
    );
  }
}

class Community extends StatelessWidget {
  const Community({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'NanumSquare');
    var size = MediaQuery.of(context).size;
    final now = DateTime.now();
    String month = DateFormat('MM.dd').format(DateTime.now());
    String time = DateFormat('hh:mm').format(DateTime.now());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 90),
              decoration: BoxDecoration(
                  color: Color(bgColor(17)), // 여기서 배경 색상
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: ListView.builder(
                itemCount: messages.length,
                shrinkWrap: false,
                padding: EdgeInsets.only(top: 20, bottom: 65),
                //physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index].messageType == "sender"
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (messages[index].messageType == "sender"
                              ? Color(sendorColor(17)) // 여기서 내 말풍선 색상
                              : Color(0xffffffff)),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text.rich(
                            textAlign: TextAlign.right,
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: messages[index].messageContent,
                                style: TextStyle(fontSize: 15),
                              ),
                              TextSpan(
                                text: '\n\n' + messages[index].nickname,
                                style: TextStyle(fontSize: 10),
                              ),
                              TextSpan(
                                text: '  |  $time',
                                style: TextStyle(fontSize: 10),
                              ),
                            ])),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                color: Color(0xffffffff),
                height: 90,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    '울산 현대 축구단 팬 커뮤니티', // team 이름 + 팬 커뮤니티 출력
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              margin: EdgeInsets.only(bottom: 5),
              height: 60,
              width: size.width * 0.97,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "팀을 응원하는 메세지를 적어주세요!",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Color(0xff122054),
                    elevation: 0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<ChatMessage> messages = [
  ChatMessage(
      messageContent: "오늘도 화이팅 ❤️", messageType: "receiver", nickname: "강희주"),
  ChatMessage(messageContent: "가보자고 ~", messageType: "sender", nickname: "정채린"),
];

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

int bgColor(int id) {
  switch (id) {
    case 1: // 강원
      return 0xff27954;
    case 2: // 경남
      return 0xffd93829;
    case 3: // 광주
      return 0xffbf303c;
    case 4: // 김천
      return 0xff122a40;
    case 5: // 김포
      return 0xff28d40;
    case 6: // 대구
      return 0xff3f83bf;
    case 7: // 대전
      return 0xff1e3859;
    case 8: // 부산
      return 0xff9f2616;
    case 9: // 부천
      return 0xff0d0d0d;
    case 10: // 서울
      return 0xff0d0d0d;
    case 11: // 서울E
      return 0xff56688c;
    case 12: // 성남
      return 0xff262324;
    case 13: // 수원
      return 0xff265da6;
    case 14: // 수원FC
      return 0xff183459;
    case 15: // 안산
      return 0xff3f8c76;
    case 16: // 안양
      return 0xff3d2473;
    case 17: // 울산
      return 0xff006BB6;
    case 18: // 인천
      return 0xff2e6ea6;
    case 19: // 전남
      return 0xff736522;
    case 20: // 전북
      return 0xff327343;
    case 21: // 제주
      return 0xffa62d37;
    case 22: // 천안
      return 0xff73b2d9;
    case 23: // 충남아산
      return 0xff1c418c;
    case 24: // 청주
      return 0xff1d2659;
    case 25: // 포항
      return 0xff0d0d0d;

    default:
      return 0xff122054;
  }
}

int sendorColor(int id) {
  switch (id) {
    case 1: // 강원
      return 0xfff2b544;
    case 2: //경남
      return 0xffdbab3a;
    case 3: // 광주
      return 0xffd9a9a9;
    case 4: // 김천
      return 0xffa69472;
    case 5: // 김포
      return 0xffbfaa6b;
    case 6: // 대구
      return 0xffaed8f2;
    case 7: // 대전
      return 0xffbfad50;
    case 8: // 부산
      return 0xffd9ca9c;
    case 9: // 부천
      return 0xffbf8484;
    case 10: // 서울
      return 0xffd97e7e;
    case 11: // 서울E
      return 0xffd9caad;
    case 12: // 성남
      return 0xff737373;
    case 13: // 수원
      return 0xfff2c9c9;
    case 14: // 수원FC
      return 0xffd9b471;
    case 15: // 안산
      return 0xffbfad50;
    case 16: // 안양
      return 0xffa99fbf;
    case 17: // 울산
      return 0xffffc518;
    case 18: // 인천
      return 0xffd9c24e;
    case 19: // 전남
      return 0xfff2c84b;
    case 20: // 전북
      return 0xffd2cb47;
    case 21: // 제주
      return 0xffdc9466;
    case 22: // 천안
      return 0xffd6e8f5;
    case 23: // 충남아산
      return 0xfff2ca50;
    case 24: // 청주
      return 0xfff09c99;
    case 25: // 포항
      return 0xffd95a4e;

    default:
      return 0xffffffff;
  }
}
