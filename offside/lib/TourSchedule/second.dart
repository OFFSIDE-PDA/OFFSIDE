import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:offside/TourSchedule/tourPlan.dart';
import 'package:offside/data/api/map_api.dart';
import 'package:offside/data/api/tour_api.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:offside/data/model/tour_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory(
      {Key? key,
      required this.context,
      required this.home,
      required this.size,
      required this.lat,
      required this.lng,
      required this.starty,
      required this.startx})
      : super(key: key);
  final BuildContext context;
  final String home;
  final Size size;
  final double lat;
  final double lng;
  final double starty;
  final double startx;
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
              border: Border.all(
                  color: const Color.fromARGB(255, 55, 91, 199), width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 11)),
                filled: true,
                prefixIcon:
                    const Icon(Icons.search, color: Colors.grey, size: 23),
                suffixIcon: InkWell(
                  onTap: textFieldClear,
                  child: const Icon(Icons.clear, color: Colors.grey, size: 23),
                )),
            style: TextStyle(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 11),
                fontWeight: FontWeight.w500),
            onFieldSubmitted: search,
          )),
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return LocationList(
                        tourInfo: searchList.isEmpty ? info : searchList,
                        category: category,
                        choose: widget,
                        index: index,
                        starty: widget.starty,
                        startx: widget.startx);
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
      required this.index,
      required this.starty,
      required this.startx});

  final List tourInfo;
  final int category;
  final ChooseCategory choose;
  final int index;
  final double starty;
  final double startx;

  @override
  State<LocationList> createState() => _LocationList();
}

class _LocationList extends State<LocationList> {
  late WebViewController _mapController;
  late Future<List> points;
  bool openFlag = false;

  @override
  Widget build(BuildContext context) {
    if (openFlag == true) {
      print('naver api start');
      points = getRoute(
          widget.startx,
          widget.starty,
          widget.tourInfo[widget.index].mapx,
          widget.tourInfo[widget.index].mapy,
          context);
    }
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromARGB(255, 194, 194, 194), width: 1))),
        child: ExpansionTile(
            backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
            tilePadding: const EdgeInsets.only(left: 10),
            onExpansionChanged: (value) {
              setState(() {
                value == true ? openFlag = true : openFlag = false;
              });
            },
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
                        child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            text: TextSpan(
                                text: widget.tourInfo[widget.index].title,
                                style: TextStyle(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 10),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                )))),
                    const SizedBox(height: 8),
                    SizedBox(
                        width: widget.choose.size.width * 0.55,
                        child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            text: TextSpan(
                                text: widget.tourInfo[widget.index].addr,
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 9),
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromARGB(
                                        255, 163, 163, 163)))))
                  ])
            ]),
            children: [
              openFlag == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FutureBuilder<List>(
                          future: points,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List info = snapshot.data!;
                              return KakaoMapView(
                                width: widget.choose.size.width * 0.95,
                                height: widget.choose.size.width * 0.8,
                                kakaoMapKey: 'a8bd91fccbb230b5011148456b3cd404',
                                zoomLevel: 10,
                                lat: info[0]['y'],
                                lng: info[0]['x'],
                                mapController: (controller) {
                                  _mapController = controller;
                                },
                                customScript: '''
                              var markers = [];
                  
                              function addMarker(position) {
                                var marker = new kakao.maps.Marker({position: position});
                                marker.setMap(map);
                                markers.push(marker);
                              }
                  
                              addMarker(new kakao.maps.LatLng(${info.first['y']}, ${info.first['x']}));
                              addMarker(new kakao.maps.LatLng(${info.last['y']}, ${info.last['x']}));
                  
                              var linePath = [];
                              $info.map((item) => {
                                linePath.push(new kakao.maps.LatLng(item.y, item.x));
                              });
                  
                              const polyline = new kakao.maps.Polyline({
                                  map: map,
                                  path: linePath,
                                  strokeWeight: 3,
                                  strokeColor: '#ff0000',
                                  strokeOpacity: 0.7,
                                  strokeStyle: 'solid'
                                });
                                polyline.setMap(map);
                              ''',
                              );
                            } else if (snapshot.hasError) {
                              return const Text('error');
                            }
                            return const Center(
                                child: CupertinoActivityIndicator());
                          }),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('not open'),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () async {
                        // setState(() {
                        //   selectedList.add(widget.tourInfo[widget.index]);
                        // // });
                        if (await NaviApi.instance.isKakaoNaviInstalled()) {
                          // 카카오내비 앱으로 길 안내하기, WGS84 좌표계 사용
                          await NaviApi.instance.navigate(
                            destination: Location(
                                name: widget.tourInfo[widget.index].title,
                                x: widget.tourInfo[widget.index].mapx,
                                y: widget.tourInfo[widget.index].mapy),
                            option: NaviOption(coordType: CoordType.wgs84),
                            // 경유지 추가
                            // viaList: [
                            //   Location(
                            //       name: '판교역 1번출구',
                            //       x: '127.111492',
                            //       y: '37.395225'),
                            // ],
                          );
                        } else {
                          // 카카오내비 설치 페이지로 이동
                          launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.near_me_outlined,
                                  size: 23,
                                  color: Color.fromRGBO(57, 142, 223, 1)),
                              const SizedBox(height: 3),
                              Text('Kakao Navi',
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 11),
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          57, 142, 223, 1)))
                            ]),
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          selectedList.add(widget.tourInfo[widget.index]);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_location_alt_outlined,
                                  size: 23,
                                  color: Color.fromRGBO(57, 142, 223, 1)),
                              const SizedBox(height: 3),
                              Text('추가하기',
                                  style: TextStyle(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 11),
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          57, 142, 223, 1)))
                            ]),
                      ))
                ],
              ),
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

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}
