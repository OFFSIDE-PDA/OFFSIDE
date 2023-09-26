import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:offside/data/view/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:offside/data/model/message.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  Community createState() => Community();
}

class Community extends ConsumerState<CommunityPage>
    with WidgetsBindingObserver {
  TextStyle style = const TextStyle(fontSize: 18.0);
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
    final teaminfo = ref.read(teamInfoViewModelProvider).teamInfoList;
    final chatView = ref.read(chatViewModelProvider);
    int team = user.user!.team!;
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
                _scrollController.position.maxScrollExtent.toInt() -
                    size.height * 0.8) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          setState(() {
            showToBottom = true;
          });
        }
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        setState(() {
          showToBottom = false;
        });
      }
    });

    return chatmodel.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (communityMSG) {
          lastWriter = communityMSG.last.writer!;
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 70),
                      decoration: BoxDecoration(
                          color: Color(teaminfo[team].color[0]), // 배경 색상
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)),
                          image: DecorationImage(
                              image: NetworkImage(teaminfo[team].logoImg),
                              colorFilter: ColorFilter.mode(
                                  Color(teaminfo[team].color[0])
                                      .withOpacity(0.3),
                                  BlendMode.dstATop))),
                      child: Scrollbar(
                        controller: _scrollController, // 스크롤 컨트롤러
                        thickness: 4.0, // 스크롤 너비
                        radius: const Radius.circular(8.0), // 스크롤 라운딩
                        child: ListView.builder(
                          controller: _scrollController, // 스크롤 컨트롤러
                          itemCount: communityMSG.length,
                          shrinkWrap: false,
                          padding: const EdgeInsets.only(top: 20, bottom: 65),
                          itemBuilder: (context, index) {
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
                                        ? Color(
                                            teaminfo[team].color[1]) // 내 말풍선 색상
                                        : const Color(0xffffffff)),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Text.rich(
                                      textAlign: TextAlign.right,
                                      TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: communityMSG
                                              .elementAt(index)
                                              .text,
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
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xffffffff),
                        height: 70,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 15,
                                )),
                            Text(
                              '${teaminfo[team].fullName} 커뮤니티', // team 이름 + 팬 커뮤니티 출력
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
                                    minimumSize: MaterialStatePropertyAll(
                                        Size(100, 40))),
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Color(teaminfo[team].color[0]),
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
                          padding:
                              const EdgeInsets.only(left: 3, bottom: 3, top: 3),
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
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 15),
                                    controller: _text,
                                    decoration: const InputDecoration(
                                        hintText: "팀을 응원하는 메세지를 적어주세요!",
                                        hintStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                  ),
                                ),
                                FloatingActionButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await chatView.addChat(
                                            team: user.user!.team!,
                                            text: _text.text,
                                            uid: uid,
                                            writer: nickname);
                                        _text.clear();
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
            ),
          );
        });
  }
}
