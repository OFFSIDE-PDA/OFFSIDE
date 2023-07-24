import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../user_view_model.dart';
import 'ChatData.dart';

class CommunityPage extends ConsumerStatefulWidget {
  @override
  Community createState() => Community();
}

class Community extends ConsumerState<CommunityPage> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TextEditingController _text;
  final now = DateTime.now();
  String time = DateFormat('hh:mm').format(DateTime.now());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    String? _team = user.user!.team;
    String? _nickname = user.user!.nickname;
    String? _UID = user.user!.uid;
    var size = MediaQuery.of(context).size;
    List<List> communityMSG = [];

    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('community')
            .where("team", isEqualTo: _team)
            .orderBy("time")
            .snapshots(),
        builder: (context, snapshot) {
          final messages = snapshot.data?.docs;

          for (var message in messages!) {
            communityMSG.add([
              CommunityData(
                  message['team'],
                  message['uid'],
                  message['nickname'],
                  message['time'],
                  message['time_pt'],
                  message['text'])
            ]);
          }

          return Scaffold(
            body: Stack(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 90),
                    decoration: BoxDecoration(
                        color: Color(bgColor(_team!)), // 여기서 배경 색상
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: false,
                      padding: EdgeInsets.only(top: 20, bottom: 65),
                      //physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        //index = messages.length;
                        return Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (communityMSG[index][0].D_uid == _UID
                                ? Alignment.topRight
                                : Alignment.topLeft),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (communityMSG[index][0].D_uid == _UID
                                    ? Color(sendorColor(_team)) // 여기서 내 말풍선 색상
                                    : Color(0xffffffff)),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Text.rich(
                                  textAlign: TextAlign.right,
                                  TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: communityMSG[index][0].D_text,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    TextSpan(
                                      text: '\n\n' +
                                          communityMSG[index][0].D_nickname,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    TextSpan(
                                      text: '  |  ' +
                                          communityMSG[index][0].D_time_pt,
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
                          _team + ' 팬 커뮤니티', // team 이름 + 팬 커뮤니티 출력
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    margin: EdgeInsets.only(bottom: 5),
                    height: 60,
                    width: size.width * 0.97,
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _text,
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await firestore.collection('community').add({
                                    'team': _team,
                                    'uid': _UID,
                                    'nickname': _nickname,
                                    'time': now,
                                    'time_pt': time,
                                    'text': _text.text
                                  });
                                } catch (e) {
                                  print("$e 데이터 저장 실패");
                                }
                              }
                            },
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
                ),
              ],
            ),
          );
        });
  }
}

int bgColor(String team) {
  switch (team) {
    case '강원 FC': // 강원
      return 0xff27954;
    case '경남 FC': // 경남
      return 0xffd93829;
    case '광주 FC': // 광주
      return 0xffbf303c;
    case '김천 상무 FC': // 김천
      return 0xff122a40;
    case '김포 FC': // 김포
      return 0xff28d40;
    case '대구 FC': // 대구
      return 0xff3f83bf;
    case '대전 하나 시티즌': // 대전
      return 0xff1e3859;
    case '부산 아이파크': // 부산
      return 0xff9f2616;
    case '부천 FC 1995': // 부천
      return 0xff0d0d0d;
    case 'FC 서울': // 서울
      return 0xff0d0d0d;
    case '서울 이랜드 FC': // 서울E
      return 0xff56688c;
    case '성남 FC': // 성남
      return 0xff262324;
    case '수원 삼성 블루윙즈': // 수원
      return 0xff265da6;
    case '수원 FC': // 수원FC
      return 0xff183459;
    case '안산 그리너스 FC': // 안산
      return 0xff3f8c76;
    case 'FC 안양': // 안양
      return 0xff3d2473;
    case '울산 현대': // 울산
      return 0xff006BB6;
    case '인천 유나이티드': // 인천
      return 0xff2e6ea6;
    case '전남 드래곤즈': // 전남
      return 0xff736522;
    case '전북 현대 모터스': // 전북
      return 0xff327343;
    case '제주 유나이티드': // 제주
      return 0xffa62d37;
    case '천안 시티 FC': // 천안
      return 0xff73b2d9;
    case '충남 아산 FC': // 충남아산
      return 0xff1c418c;
    case '충북 청주 FC': // 청주
      return 0xff1d2659;
    case '포항 스틸러스': // 포항
      return 0xff0d0d0d;

    default:
      return 0xff122054;
  }
}

int sendorColor(String team) {
  switch (team) {
    case '강원 FC': // 강원
      return 0xfff2b544;
    case '경남 FC': //경남
      return 0xffdbab3a;
    case '광주 FC': // 광주
      return 0xffd9a9a9;
    case '김천 상무 FC': // 김천
      return 0xffa69472;
    case '김포 FC': // 김포
      return 0xffbfaa6b;
    case '대구 FC': // 대구
      return 0xffaed8f2;
    case '대전 하나 시티즌': // 대전
      return 0xffbfad50;
    case '부산 아이파크': // 부산
      return 0xffd9ca9c;
    case '부천 FC 1995': // 부천
      return 0xffbf8484;
    case 'FC 서울': // 서울
      return 0xffd97e7e;
    case '서울 이랜드 FC': // 서울E
      return 0xffd9caad;
    case '성남 FC': // 성남
      return 0xff737373;
    case '수원 삼성 블루윙즈': // 수원
      return 0xfff2c9c9;
    case '수원 FC': // 수원FC
      return 0xffd9b471;
    case '안산 그리너스 FC': // 안산
      return 0xffbfad50;
    case 'FC 안양': // 안양
      return 0xffa99fbf;
    case '울산 현대': // 울산
      return 0xffffc518;
    case '인천 유나이티드': // 인천
      return 0xffd9c24e;
    case '전남 드래곤즈': // 전남
      return 0xfff2c84b;
    case '전북 현대 모터스': // 전북
      return 0xffd2cb47;
    case '제주 유나이티드': // 제주
      return 0xffdc9466;
    case '천안 시티 FC': // 천안
      return 0xffd6e8f5;
    case '충남 아산 FC': // 충남아산
      return 0xfff2ca50;
    case '충북 청주 FC': // 청주
      return 0xfff09c99;
    case '포항 스틸러스': // 포항
      return 0xffd95a4e;

    default:
      return 0xffffffff;
  }
}
