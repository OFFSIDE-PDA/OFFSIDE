import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile.dart';
import 'package:offside/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/login/login.dart';
import 'myteam.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var contextHeight = size.height;
    var remainHeight = contextHeight - 171;

    var topH = remainHeight * (1 / 2) - 20;
    var midH = remainHeight * (1 / 4) + 20;
    var botH = remainHeight * (1 / 4);

    return (Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 55,
          child: const Padding(
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
          height: topH,
          alignment: Alignment.center,
          child: (Profile()),
        ),
        Container(
          height: midH,
          alignment: Alignment.center,
          child: (Second()),
        ),
        Container(
          height: botH,
          alignment: Alignment.center,
          child: (Under()),
        )
      ]),
    ));
  }
}

class Profile extends ConsumerStatefulWidget {
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
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    final user = ref.watch(userViewModelProvider);
    return (Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Color.fromRGBO(18, 32, 84, 1),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  teamImg,
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
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(18, 32, 84, 1),
                            fontWeight: FontWeight.w700),
                      ),
                      Container(height: 5),
                      user.user!.email != null
                          ? Text(
                              user.user!.email!,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          : SizedBox(),
                      Container(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            user.user!.team!,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
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
                  child: Text(
                    "회원 정보 수정하기",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.grey),
                  ),
                )
              ],
            )
          ]),
    ));
  }
}

class Second extends StatelessWidget {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    var wSize = size.width * (2 / 6) + 20;
    return (Container(
      margin: const EdgeInsets.all(30),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // padding: const EdgeInsets.all(8),
            width: wSize,
            height: 90,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color.fromRGBO(18, 32, 84, 1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (body) => MyTeam()),
                );
                // 내 응원팀 경기일정 보기로 이동
              },
              child: Column(
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
            height: 90,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color.fromRGBO(18, 32, 84, 1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                // 내 여행 일정 페이지로 이동
              },
              child: Column(
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

class Under extends ConsumerWidget {
  const Under({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
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
