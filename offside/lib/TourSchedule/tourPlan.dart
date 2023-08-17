import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/Kleague/TeamInfo.dart';
import 'package:offside/data/model/team_transfer.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:offside/data/view/tour_view_model.dart';

class TourPlan extends ConsumerStatefulWidget {
  const TourPlan({super.key, required this.home, required this.away});
  final String home;
  final String away;
  @override
  _TourPlan createState() => _TourPlan();
}

class _TourPlan extends ConsumerState<TourPlan> {
  int step = 1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          // AppBar(),
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin: const EdgeInsets.only(bottom: 10),
              child: Text('나의 여행 일정',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 18),
                      fontFamily: 'NanumSquare'))),
          PlanStep(size: size, step: step),
          const SizedBox(height: 30),
          returnStep(step, size),
        ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(fit: StackFit.expand, children: [
          Positioned(
              left: 25,
              bottom: 15,
              child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (step == 1) {
                        Navigator.pop(context);
                      } else {
                        step -= 1;
                      }
                    });
                  },
                  backgroundColor:
                      const Color.fromRGBO(33, 58, 135, 1), // <-- Button color
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 25))),
          Positioned(
              bottom: 15,
              right: 25,
              child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (step == 3) {
                      } else {
                        step += 1;
                      }
                    });
                  },
                  backgroundColor:
                      const Color.fromRGBO(33, 58, 135, 1), // <-- Button color
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: const Icon(Icons.arrow_forward,
                      color: Colors.white, size: 25)))
          // Add more floating buttons if you want
          // There is no limit
        ]));
  }

  returnStep(int step, Size size) {
    if (step == 1) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GetLocation(context: context, title: '현재 위치', text: '충북대학교'),
          GetLocation(context: context, title: '경기장 위치', text: widget.home),
        ]),
        Container(
            margin: const EdgeInsets.all(10),
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2, color: const Color.fromARGB(255, 54, 54, 54))))
      ]);
    } else if (step == 2) {
      return ChooseCategory(context: context, size: size, home: widget.home);
    } else {
      return Container(
          margin: const EdgeInsets.all(10),
          width: 300,
          height: 300,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2, color: Color.fromARGB(255, 79, 38, 145))));
    }
  }
}

class GetLocation extends StatelessWidget {
  const GetLocation(
      {super.key,
      required this.context,
      required this.title,
      required this.text});
  final BuildContext context;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            title == "현재 위치"
                ? const Icon(Icons.location_on_outlined)
                : const Icon(Icons.location_on,
                    color: Color.fromRGBO(14, 32, 87, 1)),
            const SizedBox(width: 5),
            Text(title,
                style: TextStyle(
                    color: const Color.fromRGBO(14, 32, 87, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 16),
                    fontFamily: 'NanumSquare'))
          ]),
          const SizedBox(height: 5),
          Text(text,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 14),
                  color: const Color.fromRGBO(128, 122, 122, 1),
                  fontFamily: 'NanumSquare'))
        ]);
  }
}

class ChooseCategory extends ConsumerStatefulWidget {
  const ChooseCategory(
      {Key? key, required this.context, required this.home, required this.size})
      : super(key: key);
  final BuildContext context;
  final String home;
  final Size size;
  @override
  createState() => _ChooseCategory();
}

class _ChooseCategory extends ConsumerState<ChooseCategory> {
  String category = 'tour';

  void chooseCategory(String value) {
    setState(() {
      category = value;
    });
  }

  // final List<Item> _data = generateItems(8);
  @override
  Widget build(BuildContext context) {
    var tourData = ref.read(tourViewModelProvider);
    var tourInfo = tourData.getTourInfo(widget.home);
    print(tourInfo[category]);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CategoryBtn(
              context: context,
              category: category,
              info: 'tour',
              text: "관광지",
              choose: chooseCategory),
          CategoryBtn(
              context: context,
              category: category,
              info: 'culture',
              text: "문화시설",
              choose: chooseCategory),
          CategoryBtn(
              context: context,
              category: category,
              info: 'hotel',
              text: "숙박",
              choose: chooseCategory),
          CategoryBtn(
              context: context,
              category: category,
              info: 'food',
              text: "음식점",
              choose: chooseCategory)
        ]),
      ),
      // InfoList(info: tourInfo[category])
      const SizedBox(height: 10),
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: tourInfo[category].length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.black, width: 1.5),
                )),
                child: ExpansionTile(
                    backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
                    tilePadding: const EdgeInsets.only(left: 10),
                    trailing: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(14, 32, 87, 1),
                            child: Icon(
                                size: 25,
                                Icons.expand_more,
                                color: Colors.white))),
                    title: Row(children: [
                      Image.network(tourInfo[category][index].img,
                          width: widget.size.width * 0.2,
                          fit: BoxFit.fill,
                          errorBuilder: (context, url, error) => SizedBox(
                              width: widget.size.width * 0.2,
                              child: Image.asset('images/mainpage/logo.png'))),
                      const SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: widget.size.width * 0.5,
                                child: Flexible(
                                    child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text:
                                                tourInfo[category][index].title,
                                            style: TextStyle(
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 14),
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontFamily: 'NanumSquare'))))),
                            SizedBox(
                                width: widget.size.width * 0.5,
                                child: Flexible(
                                    child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text:
                                                tourInfo[category][index].addr,
                                            style: TextStyle(
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 11),
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontFamily: 'NanumSquare')))))
                          ])
                    ]),
                    children: [
                      Container(
                        width: widget.size.width,
                        height: widget.size.width,
                        color: const Color.fromRGBO(239, 239, 239, 1),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.red)),
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 50),
                          width: widget.size.width * 0.3,
                          height: widget.size.width * 0.25,
                        ),
                      )
                    ]));
          }),
      const SizedBox(height: 10),
    ]);
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn(
      {super.key,
      required this.context,
      required this.category,
      required this.info,
      required this.text,
      required this.choose});

  final BuildContext context;
  final String category;
  final String info;
  final String text;
  final Function choose;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          choose(info);
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: category == info
                ? const Color.fromRGBO(14, 32, 87, 1)
                : Colors.white,
            side: BorderSide(
                color: const Color.fromARGB(255, 149, 149, 149),
                width: category == info ? 0.0 : 2.0)),
        child: Text(text,
            style: TextStyle(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                color: category == info
                    ? Colors.white
                    : const Color.fromARGB(255, 125, 125, 125),
                fontFamily: 'NanumSquare')));
  }
}

class PlanStep extends StatelessWidget {
  const PlanStep({super.key, required this.size, required this.step});
  final Size size;
  final int step;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.black, width: 1.5),
                bottom: BorderSide(color: Colors.black, width: 1.5))),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Step(step: step, num: 1, text: '이동 수단 결정'),
          const Icon(Icons.more_horiz, color: Color.fromRGBO(14, 32, 87, 1)),
          Step(step: step, num: 2, text: '방문지 선택'),
          const Icon(Icons.more_horiz, color: Color.fromRGBO(14, 32, 87, 1)),
          Step(step: step, num: 3, text: '여행 일정 확인')
        ]));
  }
}

class Step extends StatelessWidget {
  const Step(
      {super.key, required this.step, required this.num, required this.text});
  final int step;
  final int num;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: step == num ? selectedBox() : unSelectedBox(),
          child: Text('$num',
              style:
                  step == num ? selectedNum(context) : unSelectedNum(context))),
      const SizedBox(height: 10),
      Text(text,
          style: step == num ? selectedText(context) : unSelectedText(context))
    ]);
  }
}

BoxDecoration selectedBox() {
  return BoxDecoration(
      color: const Color.fromRGBO(14, 32, 87, 1),
      borderRadius: BorderRadius.circular(10));
}

BoxDecoration unSelectedBox() {
  return BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(14, 32, 87, 1), width: 3),
      borderRadius: BorderRadius.circular(10));
}

TextStyle selectedNum(BuildContext context) {
  return TextStyle(
      fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 20),
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontFamily: 'NanumSquare');
}

TextStyle unSelectedNum(BuildContext context) {
  return TextStyle(
      fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 20),
      fontWeight: FontWeight.w500,
      color: const Color.fromRGBO(14, 32, 87, 1),
      fontFamily: 'NanumSquare');
}

TextStyle selectedText(BuildContext context) {
  return TextStyle(
      fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 15),
      fontWeight: FontWeight.w600,
      fontFamily: 'NanumSquare');
}

TextStyle unSelectedText(BuildContext context) {
  return TextStyle(
      fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 13),
      fontWeight: FontWeight.w600,
      fontFamily: 'NanumSquare');
}
