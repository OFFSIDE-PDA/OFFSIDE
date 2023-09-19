import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

List selectedList = [];

class TourPlan extends ConsumerStatefulWidget {
  const TourPlan(
      {super.key,
      required this.home,
      required this.away,
      required this.date,
      required this.time});
  final int home;
  final int away;
  final String date;
  final String time;
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

  getDate(date) =>
      '${date[0]}${date[1]}.${date[2]}${date[3]}.${date[4]}${date[5]}';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    final user = ref.watch(userViewModelProvider);
    var uid = user.user!.uid;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          // AppBar(),
          Container(
            // height: size.height * 0.2,
            alignment: Alignment.topLeft,
            child: SizedBox(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('My Travel',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 14),
                              color: Color.fromRGBO(33, 58, 135, 1))),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3.0),
                        child: Icon(
                          Icons.card_travel,
                          size: 22,
                          color: Color.fromRGBO(91, 143, 255, 1),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          SizedBox(height: size.height * 0.015),
          PlanStep(size: size, step: step),
          SizedBox(height: size.height * 0.025),
          returnStep(step, size, teamInfoList, uid),
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
                        selectedList.clear();
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
                        selectedList.isNotEmpty
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('20${getDate(widget.date)}'),
                                      content: const SingleChildScrollView(
                                          child: ListBody(children: <Widget>[
                                        Text('여행일정을 저장하시겠습니까?')
                                      ])),
                                      actions: [
                                        TextButton(
                                            child: const Text('취소'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        TextButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              createTourPlan(
                                                  uid,
                                                  selectedList,
                                                  widget.date,
                                                  widget.home,
                                                  widget.away,
                                                  widget.time);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(saveSnackBar);
                                              Navigator.of(context).pop();
                                            })
                                      ]);
                                })
                            : ScaffoldMessenger.of(context)
                                .showSnackBar(emptySnackBar);
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
                  child: step == 3
                      ? Icon(Icons.check, color: Colors.white, size: 25)
                      : Icon(Icons.arrow_forward,
                          color: Colors.white, size: 25)))
        ]));
  }

  returnStep(int step, Size size, List<TeamInfo> teamInfoList, String? uid) {
    var size = MediaQuery.of(context).size;
    if (step == 1) {
      return Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetLocation(context: context, title: 'NOW', text: '충북대학교'),
              const Icon(
                Icons.arrow_right_alt,
                color: Color.fromRGBO(110, 110, 110, 1),
                size: 25,
              ),
              GetLocation(
                  context: context,
                  title: 'STADIUM',
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
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01, horizontal: size.width * 0.035),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 48, 84, 190), width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '20${getDate(widget.date)}',
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12),
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 83, 83, 83)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        teamInfoList[widget.home].stadium,
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 11),
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 121, 121, 121)),
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: size.width * 0.08,
                                height: size.width * 0.08,
                                child: Image.network(
                                    teamInfoList[widget.home].logoImg)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(teamInfoList[widget.home].middleName,
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 12),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Text(' vs ',
                            style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 14),
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: size.width * 0.08,
                                height: size.width * 0.08,
                                child: Image.network(
                                    teamInfoList[widget.away].logoImg)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(teamInfoList[widget.away].middleName,
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 12),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center),
                          ],
                        )
                      ])
                ])),
        Container(
            height: selectedList.length * 80,
            margin: const EdgeInsets.only(top: 15),
            child: ReorderableListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                children: <Widget>[
                  for (int index = 0; index < selectedList.length; index += 1)
                    InkWell(
                      key: Key('$index'),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(selectedList[index].title,
                                      style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 13),
                                          fontWeight: FontWeight.w600)),
                                  content: const SingleChildScrollView(
                                      child: ListBody(children: <Widget>[
                                    Text('해당 일정을 삭제하시겠습니까?')
                                  ])),
                                  actions: [
                                    TextButton(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    TextButton(
                                        child: const Text('확인'),
                                        onPressed: () {
                                          setState(() {
                                            selectedList.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
                                        })
                                  ]);
                            });
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 207, 207, 207)))),
                          child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(selectedList[index].img,
                                    width: size.width * 0.18,
                                    errorBuilder: (context, url, error) => SizedBox(
                                        width: size.width * 0.18,
                                        child: Image.asset(
                                            'assets/images/mainpage/logo.png'))),
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('${selectedList[index].title}',
                                        style: TextStyle(
                                            fontSize: const AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 12),
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${getType[selectedList[index].typeId]}',
                                        style: TextStyle(
                                            fontSize: const AdaptiveTextSize()
                                                .getadaptiveTextSize(
                                                    context, 11),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ),
                              subtitle: Text(selectedList[index].addr,
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 11),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey)))),
                    )
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = selectedList.removeAt(oldIndex);
                    selectedList.insert(newIndex, item);
                  });
                })),
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
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title == "NOW"
                    ? const Icon(
                        Icons.location_on_outlined,
                        size: 22,
                      )
                    : const Icon(Icons.location_on,
                        size: 22, color: Color.fromRGBO(14, 32, 87, 1)),
                const SizedBox(width: 5),
                Text(title,
                    style: TextStyle(
                      color: const Color.fromRGBO(14, 32, 87, 1),
                      fontWeight: FontWeight.w600,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 13),
                    )),
              ]),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(text,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  color: const Color.fromRGBO(128, 122, 122, 1),
                )),
          )
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
    var size = MediaQuery.of(context).size;
    futureTourData = getTourData(widget.lat, widget.lng, category);

    search(string) {
      String searchText = textEditingController.value.text;
      futureTourData.then((value) {
        var tmpList = [];
        for (var item in value) {
          String addr = item.addr!;
          String title = item.title!;
          if (addr.contains(searchText) || title.contains(searchText)) {
            tmpList.add(item);
          }
        }
        return tmpList;
      }).then((value) {
        setState(() {
          searchList = value;
        });
      });
    }

    return Column(children: [
      Container(
          height: size.height * 0.04,
          width: size.width * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromARGB(255, 55, 91, 199), width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: '검색어를 입력하세요',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12)),
                    filled: true,
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.grey, size: 21),
                    suffixIcon: InkWell(
                      onTap: textFieldClear,
                      child:
                          const Icon(Icons.clear, color: Colors.grey, size: 21),
                    )),
                style: TextStyle(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 12)),
                onFieldSubmitted: search,
              ))),
      SizedBox(height: size.height * 0.02),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CategoryBtn(
                context: context,
                category: category,
                id: 12,
                text: "관광지",
                choose: chooseCategory),
            CategoryBtn(
                context: context,
                id: 14,
                category: category,
                text: "문화시설",
                choose: chooseCategory),
            CategoryBtn(
                context: context,
                id: 32,
                category: category,
                text: "숙박",
                choose: chooseCategory),
            CategoryBtn(
                context: context,
                id: 39,
                category: category,
                text: "음식점",
                choose: chooseCategory)
          ])),
      SizedBox(height: size.height * 0.02),
      FutureBuilder<List<TourModel>>(
          future: futureTourData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<TourModel> info = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount:
                      searchList.isEmpty ? info.length : searchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LocationList(
                        tourInfo: searchList.isEmpty ? info : searchList,
                        category: category,
                        choose: widget,
                        index: index);
                  });
            } else if (snapshot.hasError) {
              return const Center(child: Text('error'));
            }
            return const Center(child: CupertinoActivityIndicator());
          }),
      SizedBox(height: size.height * 0.02)
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
  final int category;
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
    var size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromARGB(255, 194, 194, 194), width: 1))),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(widget.tourInfo[widget.index].img,
                    width: widget.choose.size.width * 0.2,
                    fit: BoxFit.fill,
                    errorBuilder: (context, url, error) => SizedBox(
                        width: widget.choose.size.width * 0.2,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                                'assets/images/mainpage/logo.png')))),
              ),
              const SizedBox(width: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: widget.choose.size.width * 0.55,
                        child: Flexible(
                            child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(
                                    text: widget.tourInfo[widget.index].title,
                                    style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 12),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ))))),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: widget.choose.size.width * 0.55,
                        child: Flexible(
                            child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(
                                    text: widget.tourInfo[widget.index].addr,
                                    style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 11),
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 80, 80, 80),
                                    )))))
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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedList.add(widget.tourInfo[widget.index]);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_location_alt_outlined,
                          size: 23,
                          color: Color.fromRGBO(57, 142, 223, 1),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          '추가하기',
                          style: TextStyle(
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 11),
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(57, 142, 223, 1)),
                        ),
                      ],
                    )),
              )
            ]));
  }
}

class CategoryBtn extends StatefulWidget {
  const CategoryBtn(
      {super.key,
      required this.context,
      required this.id,
      required this.category,
      required this.text,
      required this.choose});

  final BuildContext context;
  final int id;
  final int category;
  final String text;
  final Function choose;

  @override
  State<CategoryBtn> createState() => _CategoryBtn();
}

class _CategoryBtn extends State<CategoryBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => widget.choose(widget.id),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: widget.category == widget.id
                ? const Color.fromRGBO(14, 32, 87, 1)
                : Colors.white,
            side: BorderSide(
                color: const Color.fromARGB(255, 149, 149, 149),
                width: widget.category == widget.id ? 0.0 : 2.0)),
        child: Text(widget.text,
            style: TextStyle(
              fontSize:
                  const AdaptiveTextSize().getadaptiveTextSize(context, 12),
              color: widget.category == widget.id
                  ? Colors.white
                  : const Color.fromARGB(255, 125, 125, 125),
            )));
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
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 245, 245),
          borderRadius: BorderRadius.circular(20),
          // border: Border(
          //     top: BorderSide(
          //         color: Color.fromARGB(255, 138, 138, 138), width: 1.3),
          //     bottom: BorderSide(
          //         color: Color.fromARGB(255, 138, 138, 138), width: 1.3))
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Step(step: step, num: 1, text: '지도 확인'),
              const Icon(
                Icons.more_horiz,
                color: Color.fromRGBO(14, 32, 87, 1),
                size: 23,
              ),
              Step(step: step, num: 2, text: '방문지 선택'),
              const Icon(Icons.more_horiz,
                  color: Color.fromRGBO(14, 32, 87, 1), size: 23),
              Step(step: step, num: 3, text: '일정 확인')
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
    var size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          width: size.width * 0.1,
          height: size.width * 0.1,
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

final emptySnackBar = SnackBar(
    content: const Text('여행 일정이 없습니다'),
    action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // Some code to undo the change.
        }));

final saveSnackBar = SnackBar(
    content: const Text('여행 일정이 저장되었습니다'),
    action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // Some code to undo the change.
        }));

BoxDecoration selectedBox() {
  return BoxDecoration(
      color: const Color.fromRGBO(14, 32, 87, 1),
      borderRadius: BorderRadius.circular(10));
}

BoxDecoration unSelectedBox() {
  return BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(14, 32, 87, 1), width: 2),
      borderRadius: BorderRadius.circular(10));
}

TextStyle selectedNum(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 15),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle unSelectedNum(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 15),
    fontWeight: FontWeight.w600,
    color: const Color.fromRGBO(14, 32, 87, 1),
  );
}

TextStyle selectedText(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 12),
    fontWeight: FontWeight.w600,
  );
}

TextStyle unSelectedText(BuildContext context) {
  return TextStyle(
    fontSize: const AdaptiveTextSize().getadaptiveTextSize(context, 12),
    fontWeight: FontWeight.w500,
  );
}
