import 'package:flutter/material.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/login/login.dart';
import 'myteam.dart';
import '../community/community.dart';
import 'package:offside/data/view/team_info_view_model.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 55,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Text(
                  "마이페이지",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(18, 32, 84, 1)),
                ),
              ),
            ),
            Container(
              // height: topH,
              alignment: Alignment.center,
              child: (const Profile()),
            ),
            Container(
              // height: midH,
              alignment: Alignment.center,
              child: (const Second()),
            ),
            Container(
              // height: thrH,
              alignment: Alignment.center,
              child: (Third()),
            ),
            Container(alignment: Alignment.center, child: (const Under()))
          ]),
    ));
  }
}

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState {
  void onPressed() {}

  var teamImg = 'icons/kOne/ulsan.svg';
  var name = '조민수';
  var email = "abs@naver.com";
  var team = '울산 현대 FC';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    final teaminfo = ref.watch(teamInfoViewModelProvider);
    return (Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: const Color.fromRGBO(18, 32, 84, 1),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  teaminfo.teamInfoList[user.user!.team!].logoImg!,
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.user!.nickname!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(18, 32, 84, 1),
                            fontWeight: FontWeight.w700),
                      ),
                      Container(height: 10),
                      user.user!.email != null
                          ? Text(
                              user.user!.email!,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            )
                          : const SizedBox(),
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            teaminfo.teamInfoList[user.user!.team!].fullName!,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit,
                    size: 20.0,
                  ),
                  Container(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Edit()));
                      // 회원정보 수정 페이지로 이동
                    },
                    child: const Text(
                      "회원 정보 수정하기",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.grey),
                    ),
                  )
                ],
              ),
            )
          ]),
    ));
  }
}

class Second extends StatelessWidget {
  const Second({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var wSize = size.width * (2 / 6) + 20;
    return (Container(
      margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // padding: const EdgeInsets.all(8),
            width: wSize,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(18, 32, 84, 1),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyTeam()),
                );
                // 내 응원팀 경기일정 보기로 이동
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "내 응원팀 경기 일정",
                    style: TextStyle(fontSize: 13),
                  ),
                  Icon(Icons.event_available,
                      color: Color.fromRGBO(18, 32, 84, 1))
                ],
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(8),
            width: wSize,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(18, 32, 84, 1),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                // 내 여행 일정 페이지로 이동
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "내 여행 일정",
                    style: TextStyle(fontSize: 13),
                  ),
                  Icon(Icons.card_travel, color: Color.fromRGBO(18, 32, 84, 1))
                ],
              ),
            ),
          )
        ],
      )),
    ));
  }
}

class Third extends StatelessWidget {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var wSize = size.width;
    // TODO: implement build
    return (Container(
        margin: const EdgeInsets.fromLTRB(30, 15, 30, 30),
        child: Container(
          // padding: const EdgeInsets.all(8),
          width: wSize,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: const Color.fromRGBO(18, 32, 84, 1),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityPage()),
              ); // 내 응원팀 커뮤니티로 이동
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "팀 커뮤니티",
                  style: TextStyle(fontSize: 13),
                ),
                Icon(Icons.forum_outlined, color: Color.fromRGBO(18, 32, 84, 1))
              ],
            ),
          ),
        )));
  }
}

class Under extends ConsumerWidget {
  const Under({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "KOREAN ",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Container(width: 1, height: 15, color: Colors.grey),
            const Text(
              " ENGLISH",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            ref.watch(userViewModelProvider).signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(33, 58, 135, 1))),
          child: const Text(
            "LOGOUT",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        )
      ],
    );
  }
}
