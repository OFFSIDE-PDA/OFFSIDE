import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:offside/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:offside/data/model/message.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  Community createState() => Community();
}

class Community extends ConsumerState<CommunityPage>
    with WidgetsBindingObserver {
  TextStyle style = const TextStyle(fontFamily: 'NanumSquare');
  late TextEditingController _text;
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool showToBottom = false;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _text.dispose();
    print("채팅 디포즈");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userViewModelProvider);

    final chatView = ref.read(chatViewModelProvider);
    String team = user.user!.team!;
    String nickname = user.user!.nickname!;
    String uid = user.user!.uid!;
    AsyncValue<Queue<Chat>> chatmodel = ref.watch(chatListProvider(team));

    var size = MediaQuery.of(context).size;
    String lastWriter = "";

    void toBottom() {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() {
        showToBottom = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //메시지를 새로 쓴 사람이 나라면 무조건 스크롤 맨 밑으로
      if (lastWriter == nickname) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        if (_scrollController.position.pixels <=
                _scrollController.position.maxScrollExtent.toInt() &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - size.height) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          setState(() {
            showToBottom = true;
          });
        }
      }
    });
    return chatmodel.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (communityMSG) {
          lastWriter = communityMSG.last.writer!;
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 90),
                    decoration: BoxDecoration(
                        color: Color(bgColor(team)), // 여기서 배경 색상
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/kLeague.png'))),
                    child: Scrollbar(
                      controller: _scrollController, // 스크롤 컨트롤러
                      thickness: 4.0, // 스크롤 너비
                      radius: const Radius.circular(8.0), // 스크롤 라운딩
                      child: ListView.builder(
                        controller: _scrollController, // 스크롤 컨트롤러
                        itemCount: communityMSG.length,
                        shrinkWrap: false,
                        padding: const EdgeInsets.only(top: 20, bottom: 65),
                        //physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          //index = messages.length;
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment:
                                  (communityMSG.elementAt(index).uid == uid
                                      ? Alignment.topRight
                                      : Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (communityMSG.elementAt(index).uid ==
                                          uid
                                      ? Color(sendorColor(team)) // 여기서 내 말풍선 색상
                                      : const Color(0xffffffff)),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text.rich(
                                    textAlign: TextAlign.right,
                                    TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            communityMSG.elementAt(index).text,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      TextSpan(
                                        text:
                                            '\n\n${communityMSG.elementAt(index).writer}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      TextSpan(
                                        text:
                                            '  |  ${DateFormat('yy-MM-dd hh:mm').format(communityMSG.elementAt(index).time!.toDate())}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ])),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      color: const Color(0xffffffff),
                      height: 90,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          '$team 팬 커뮤니티', // team 이름 + 팬 커뮤니티 출력
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      showToBottom
                          ? ElevatedButton(
                              onPressed: toBottom,
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white),
                                  minimumSize:
                                      MaterialStatePropertyAll(Size(100, 40))),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Color(bgColor(team)),
                                size: 15,
                              ))
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 10, top: 10),
                        margin: const EdgeInsets.only(bottom: 5),
                        height: 50,
                        width: size.width * 0.97,
                        child: Form(
                          key: _formKey,
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _text,
                                  decoration: const InputDecoration(
                                      hintText: "팀을 응원하는 메세지를 적어주세요!",
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              FloatingActionButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await chatView.addChat(
                                          team: team,
                                          text: _text.text,
                                          uid: uid,
                                          writer: nickname);
                                    } catch (e) {
                                      print("$e 데이터 저장 실패");
                                    }
                                  }
                                },
                                backgroundColor: const Color(0xff122054),
                                elevation: 0,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

String num2team(int team) {
  switch (team) {
    case 1:
      return '강원 FC'; // 강원
    case 2:
      return '경남 FC'; // 경남
    case 3:
      return '광주 FC'; // 광주
    case 4:
      return '김천 상무 FC'; // 김천
    case 5:
      return '김포 FC'; // 김포
    case 6:
      return '대구 FC'; // 대구
    case 7:
      return '대전 하나 시티즌'; // 대전
    case 8:
      return '부산 아이파크'; // 부산
    case 9:
      return '부천 FC 1995'; // 부천
    case 10:
      return 'FC 서울'; // 서울
    case 11:
      return '서울 이랜드 FC'; // 서울E
    case 12:
      return '성남 FC'; // 성남
    case 13:
      return '수원 삼성 블루윙즈'; // 수원
    case 14:
      return '수원 FC'; // 수원FC
    case 15:
      return '안산 그리너스 FC'; // 안산
    case 16:
      return 'FC 안양'; // 안양
    case 17:
      return '울산 현대'; // 울산
    case 18:
      return '인천 유나이티드'; // 인천
    case 19:
      return '전남 드래곤즈'; // 전남
    case 20:
      return '전북 현대 모터스'; // 전북
    case 21:
      return '제주 유나이티드'; // 제주
    case 22:
      return '천안 시티 FC'; // 천안
    case 23:
      return '충남 아산 FC'; // 충남아산
    case 24:
      return '충북 청주 FC'; // 청주
    case 25:
      return '포항 스틸러스'; // 포항
    default:
      return "팀없음";
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
