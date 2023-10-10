import 'package:flutter/material.dart';
import 'package:offside/MyPage/myTravel.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
      ),
    ));
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
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
    var size = MediaQuery.of(context).size;
    return (Container(
      margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
          size.width * 0.05, size.height * 0.02),
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
                  teaminfo.teamInfoList[user.user!.team!].logoImg,
                  width: 80,
                  height: 80,
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.user!.nickname!,
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 13),
                            color: const Color.fromRGBO(18, 32, 84, 1),
                            fontWeight: FontWeight.w700),
                      ),
                      Container(height: 10),
                      user.user!.email != null
                          ? Text(
                              user.user!.email!,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 12)),
                            )
                          : const SizedBox(),
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            teaminfo.teamInfoList[user.user!.team!].fullName,
                            style: TextStyle(
                                color: Color(teaminfo
                                    .teamInfoList[user.user!.team!].color[0]),
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 12),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit,
                    size: 17.0,
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
                      "EDIT",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 10),
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
      margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
          size.width * 0.05, size.height * 0.02),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // padding: const EdgeInsets.all(8),
            width: wSize,
            height: size.height * 0.13,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "내 응원팀 경기 일정",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 11),
                        fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.event_available,
                      color: Color.fromRGBO(18, 32, 84, 1))
                ],
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(8),
            width: wSize,
            height: size.height * 0.13,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(18, 32, 84, 1),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                // 내 여행 일정 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyTravel()),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "내 여행 일정",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 11),
                        fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.card_travel,
                      color: Color.fromRGBO(18, 32, 84, 1))
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
  const Third({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var wSize = size.width;

    return Container(
        margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
            size.width * 0.05, size.height * 0.02),
        child: Container(
          // padding: const EdgeInsets.all(8),
          width: wSize,
          height: size.height * 0.13,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "팀 커뮤니티",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 67, 67, 67),
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 12)),
                ),
                const Icon(Icons.forum_outlined,
                    color: Color.fromRGBO(18, 32, 84, 1))
              ],
            ),
          ),
        ));
  }
}

class Under extends ConsumerWidget {
  const Under({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            ref.watch(userViewModelProvider).signOut();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(33, 58, 135, 1))),
          child: Text(
            "LOGOUT",
            style: TextStyle(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 11),
                color: Colors.white),
          ),
        )
      ],
    );
  }
}
