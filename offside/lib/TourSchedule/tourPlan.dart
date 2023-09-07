import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

List selectedList = [];

class TourPlan extends ConsumerStatefulWidget {
  const TourPlan(
      {super.key, required this.home, required this.away, required this.date});
  final int home;
  final int away;
  final String date;
  @override
  _TourPlan createState() => _TourPlan();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class _TourPlan extends ConsumerState<TourPlan> {
  int step = 1;
  Set<Marker> markers = {}; // 마커 변수
  late KakaoMapController mapController;

  getDate(date) {
    return date[0] +
        date[1] +
        "." +
        date[2] +
        date[3] +
        "." +
        date[4] +
        date[5];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
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
          const SizedBox(height: 15),
          returnStep(step, size, teamInfoList),
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
        ]));
  }

  returnStep(int step, Size size, List<TeamInfo> teamInfoList) {
    if (step == 1) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GetLocation(context: context, title: '현재 위치', text: '충북대학교'),
          GetLocation(
              context: context,
              title: '경기장 위치',
              text: teamInfoList[widget.home].stadium)
        ]),
        Container(
          width: size.width,
          height: size.width,
          padding: const EdgeInsets.all(20),
          // child: KakaoMap(
          //   onMapCreated: ((controller) async {
          //     mapController = controller;

          //     if (await Permission.location.isGranted) {
          //       Position position = await Geolocator.getCurrentPosition(
          //           desiredAccuracy: LocationAccuracy.high);
          //       markers.add(Marker(
          //           markerId: '현위치',
          //           latLng: LatLng(position.latitude, position.longitude),
          //           width: 17,
          //           height: 21));
          //     }
          //     if (await Permission.location.isDenied) {}
          //     markers.add(Marker(
          //         markerId: teamInfoList[widget.home].stadium,
          //         latLng: LatLng(teamInfoList[widget.home].stadiumGeo.latitude,
          //             teamInfoList[widget.home].stadiumGeo.longitude),
          //         width: 17,
          //         height: 21));
          //     setState(() {});
          //   }),
          //   currentLevel: 8,
          //   markers: markers.toList(),
          //   center: LatLng(36.6284028, 127.4592136),
          // ),
        ),
      ]);
    } else if (step == 2) {
      return ChooseCategory(
          context: context,
          size: size,
          home: teamInfoList[widget.home].fullName,
          lat: teamInfoList[widget.home].stadiumGeo.latitude,
          lng: teamInfoList[widget.home].stadiumGeo.longitude);
    } else {
      return Column(children: [
        Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text('내가 선택한 경기',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 16),
                    fontFamily: 'NanumSquare'))),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromRGBO(14, 32, 87, 1), width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('20${getDate(widget.date)}'),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: Image.network(
                                teamInfoList[widget.home].logoImg)),
                        const SizedBox(width: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(teamInfoList[widget.home].name,
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 15)),
                                  textAlign: TextAlign.center),
                              const SizedBox(width: 5),
                              Text(' vs ',
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 15))),
                              const SizedBox(width: 5),
                              Text(teamInfoList[widget.away].name,
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 15)),
                                  textAlign: TextAlign.center),
                              const SizedBox(width: 10),
                              SizedBox(
                                  width: size.width * 0.08,
                                  height: size.width * 0.08,
                                  child: Image.network(
                                      teamInfoList[widget.away].logoImg))
                            ])
                      ])
                ])),
        Container(
          height: size.height,
          margin: const EdgeInsets.only(top: 15),
          child: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: <Widget>[
              for (int index = 0; index < selectedList.length; index += 1)
                Container(
                  key: Key('$index'),
                  decoration:
                      const BoxDecoration(border: Border(top: BorderSide())),
                  child: ListTile(
                    title: Row(
                      children: [
                        Container(
                            width: size.width * 0.7,
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Flexible(
                                child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                        text: selectedList[index].title,
                                        style: TextStyle(
                                            fontSize: const AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 14),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontFamily: 'NanumSquare'))))),
                        // Text(tourList[index].typeId)
                      ],
                    ),
                    subtitle: Container(
                        width: size.width * 0.7,
                        margin: const EdgeInsets.only(top: 5),
                        child: Flexible(
                            child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(
                                    text: selectedList[index].addr,
                                    style: TextStyle(
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 14),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: 'NanumSquare'))))),
                  ),
                ),
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = selectedList.removeAt(oldIndex);
                selectedList.insert(newIndex, item);
              });
            },
          ),
        )
      ]);
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

class ChooseCategory extends StatefulWidget {
  const ChooseCategory(
      {Key? key,
      required this.context,
      required this.home,
      required this.size,
      required this.lat,
      required this.lng})
      : super(key: key);
  final BuildContext context;
  final String home;
  final Size size;
  final double lat;
  final double lng;
  @override
  State<ChooseCategory> createState() => _ChooseCategory();
}

class _ChooseCategory extends State<ChooseCategory> {
  int category = 12;
  TextEditingController textEditingController = TextEditingController();
  List searchList = [];
  late Future<List<TourModel>> futureTourData;

  void chooseCategory(int value) {
    setState(() {
      category = value;
    });
  }

  void textFieldClear() {
    textEditingController.clear();
    setState(() {
      searchList.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    futureTourData = getTourData(widget.lat, widget.lng, category);
    search(string) {
      String searchText = textEditingController.value.text;
      var tmpList = [];
      // for (var item in futureTourData) {
      //   String addr = item.addr;
      //   String title = item.title;
      //   if (addr.contains(searchText) || title.contains(searchText)) {
      //     tmpList.add(item);
      //   }
      // }
      setState(() {
        searchList = tmpList;
      });
    }

    return Column(children: [
      Container(
          height: 30,
          width: widget.size.width * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromRGBO(14, 32, 87, 1), width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: '검색어를 입력하세요',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.grey, size: 25),
                    suffixIcon: InkWell(
                      onTap: textFieldClear,
                      child:
                          const Icon(Icons.clear, color: Colors.grey, size: 25),
                    )),
                style: TextStyle(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 12)),
                onFieldSubmitted: search,
              ))),
      const SizedBox(height: 15),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CategoryBtn(
                context: context,
                category: 12,
                info: 'tour',
                text: "관광지",
                choose: chooseCategory),
            CategoryBtn(
                context: context,
                category: 14,
                info: 'culture',
                text: "문화시설",
                choose: chooseCategory),
            CategoryBtn(
                context: context,
                category: 32,
                info: 'hotel',
                text: "숙박",
                choose: chooseCategory),
            CategoryBtn(
                context: context,
                category: 39,
                info: 'food',
                text: "음식점",
                choose: chooseCategory)
          ])),
      const SizedBox(height: 15),
      FutureBuilder<List<TourModel>>(
          future: futureTourData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<TourModel> info = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: info.length,
                  itemBuilder: (BuildContext context, int index) {
                    var size = MediaQuery.of(context).size;
                    return Column(children: [
                      Container(
                          width: size.width,
                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(info[index].img!,
                                        width: size.width * 0.15,
                                        fit: BoxFit.fill,
                                        errorBuilder: (context, url, error) =>
                                            SizedBox(
                                                width: size.width * 0.15,
                                                child: Image.asset(
                                                    'images/mainpage/logo.png')))),
                                SizedBox(width: size.width * 0.05),
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: size.width * 0.65,
                                          child: Flexible(
                                              child: RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  text: TextSpan(
                                                      text: info[index].title,
                                                      style: TextStyle(
                                                          fontSize:
                                                              const AdaptiveTextSize()
                                                                  .getadaptiveTextSize(
                                                                      context,
                                                                      13),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              Colors.black))))),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                          width: size.width * 0.65,
                                          child: Flexible(
                                              child: RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  text: TextSpan(
                                                      text: info[index].addr,
                                                      style: TextStyle(
                                                          fontSize:
                                                              const AdaptiveTextSize()
                                                                  .getadaptiveTextSize(
                                                                      context,
                                                                      11),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              67, 67, 67))))))
                                    ])
                              ])),
                      const Divider(thickness: 1, color: Colors.grey)
                    ]);
                  });
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('error'));
            }
            return const Center(child: CupertinoActivityIndicator());
          }),
      const SizedBox(height: 10)
    ]);
  }
}

class LocationList extends StatefulWidget {
  const LocationList(
      {super.key,
      required this.tourInfo,
      required this.category,
      required this.choose,
      required this.index});

  final List tourInfo;
  final String category;
  final ChooseCategory choose;
  final int index;

  @override
  State<LocationList> createState() => _LocationList();
}

class _LocationList extends State<LocationList> {
  Set<Marker> markers = {}; // 마커 변수
  late KakaoMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 1))),
        child: ExpansionTile(
            backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
            tilePadding: const EdgeInsets.only(left: 10),
            trailing: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(14, 32, 87, 1),
                    child: Icon(
                        size: 25, Icons.expand_more, color: Colors.white))),
            title: Row(children: [
              Image.network(widget.tourInfo[widget.index].img,
                  width: widget.choose.size.width * 0.2,
                  fit: BoxFit.fill,
                  errorBuilder: (context, url, error) => SizedBox(
                      width: widget.choose.size.width * 0.2,
                      child: Image.asset('images/mainpage/logo.png'))),
              const SizedBox(width: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: widget.choose.size.width * 0.5,
                        child: Flexible(
                            child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(
                                    text: widget.tourInfo[widget.index].title,
                                    style: TextStyle(
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 14),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: 'NanumSquare'))))),
                    SizedBox(
                        width: widget.choose.size.width * 0.5,
                        child: Flexible(
                            child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(
                                    text: widget.tourInfo[widget.index].addr,
                                    style: TextStyle(
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 11),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: 'NanumSquare')))))
                  ])
            ]),
            children: [
              Container(
                  width: widget.choose.size.width,
                  height: widget.choose.size.width,
                  color: const Color.fromRGBO(239, 239, 239, 1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    width: widget.choose.size.width * 0.3,
                    height: widget.choose.size.width * 0.25,
                    // child: KakaoMap(
                    //   onMapCreated: ((controller) async {
                    //     mapController = controller;
                    //     Position position = await Geolocator.getCurrentPosition(
                    //         desiredAccuracy: LocationAccuracy.high);
                    //     markers.add(Marker(
                    //         markerId: '현위치',
                    //         latLng:
                    //             LatLng(position.latitude, position.longitude),
                    //         width: 17,
                    //         height: 21));
                    //     markers.add(Marker(
                    //         markerId: widget.tourInfo[widget.index].title,
                    //         latLng: LatLng(widget.tourInfo[widget.index].lat,
                    //             widget.tourInfo[widget.index].lng),
                    //         width: 17,
                    //         height: 21));
                    //     setState(() {});
                    //   }),
                    //   currentLevel: 8,
                    //   markers: markers.toList(),
                    //   center: LatLng(
                    //       double.parse(widget.tourInfo[widget.index].lat),
                    //       double.parse(widget.tourInfo[widget.index].lng)),
                    // ),
                  )),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedList.add(widget.tourInfo[widget.index]);
                      });
                    },
                    child: const Text('추가하기')),
              )
            ]));
  }
}

class CategoryBtn extends StatefulWidget {
  const CategoryBtn(
      {super.key,
      required this.context,
      required this.category,
      required this.info,
      required this.text,
      required this.choose});

  final BuildContext context;
  final int category;
  final String info;
  final String text;
  final Function choose;

  @override
  State<CategoryBtn> createState() => _CategoryBtn();
}

class _CategoryBtn extends State<CategoryBtn> {
  Map<int, String> getType = {12: '관광지', 14: '문화시설', 32: '숙박', 39: '음식점'};

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          widget.choose(widget.category);
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: getType[widget.category] == widget.info
                ? const Color.fromRGBO(14, 32, 87, 1)
                : Colors.white,
            side: BorderSide(
                color: const Color.fromARGB(255, 149, 149, 149),
                width: getType[widget.category] == widget.info ? 0.0 : 2.0)),
        child: Text(widget.text,
            style: TextStyle(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                color: getType[widget.category] == widget.info
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
