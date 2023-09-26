import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:offside/TourSchedule/tourPlan.dart';
import 'package:offside/data/api/tour_api.dart';

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
              border: Border.all(
                  color: const Color.fromARGB(255, 55, 91, 199), width: 1),
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
                  physics: const NeverScrollableScrollPhysics(),
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
                    child: KakaoMap(
                      onMapCreated: ((controller) async {
                        mapController = controller;
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        markers.add(Marker(
                            markerId: '현위치',
                            latLng:
                                LatLng(position.latitude, position.longitude),
                            width: 17,
                            height: 21));
                        markers.add(Marker(
                            markerId: widget.tourInfo[widget.index].title,
                            latLng: LatLng(widget.tourInfo[widget.index].mapy,
                                widget.tourInfo[widget.index].mapx),
                            width: 17,
                            height: 21));
                        setState(() {});
                      }),
                      currentLevel: 8,
                      markers: markers.toList(),
                      center: LatLng(
                          double.parse(widget.tourInfo[widget.index].mapy),
                          double.parse(widget.tourInfo[widget.index].mapx)),
                    ),
                  )),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                              color: const Color.fromRGBO(57, 142, 223, 1)),
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
