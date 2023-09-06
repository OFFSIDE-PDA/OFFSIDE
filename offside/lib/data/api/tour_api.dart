import 'dart:convert';
import 'package:http/http.dart' as http;

String encodingKey =
    '4cLVOervdUDMVZg9nQde%2FY99WAtbEexyIhfSUAZEi04RhOZBXkLWHextf%2F4fT1TZtzclmylXmC7Y%2BZI5mrNq1g%3D%3D';
String url = "http://apis.data.go.kr/B551011/KorService1/locationBasedList1";
String queryParams1 = "?serviceKey=$encodingKey";

Future<List<dynamic>> getApi(Object? mapX, Object? mapY, int type) async {
  String queryParams2 =
      "&numOfRows=20&MobileOS=AND&MobileApp=Offside&_type=json&mapX=$mapX&mapY=$mapY&radius=7000&contentTypeId=$type";
  final response = await http
      .get(Uri.parse(url + queryParams1 + queryParams2))
      .then((value) {
    if (value.statusCode == 200) {
      final data = jsonDecode(utf8.decode(value.bodyBytes));
      return data['response']['body']['items']['item'];
    } else {
      throw Exception('api 호출 오류');
    }
  });
  return response;
}

Future<List<TourModel>> getTourData(double lat, double lng, int type) async {
  var data = await getApi(lat, lng, type);
  List<TourModel> tourInfo = [];
  for (var value in data) {
    tourInfo.add(TourModel(
        value['addr1'],
        value['contentid'],
        getType[value['contenttypeid']]!,
        value['firstimage'],
        value['title'],
        value['mapy'],
        value['mapx']));
  }
  return tourInfo;
}

class TourModel {
  TourModel(this.addr, this.contentId, this.typeId, this.img, this.title,
      this.lat, this.lng);
  String addr;
  String contentId;
  String typeId;
  String img;
  String title;
  String lat;
  String lng;
}

Map<int, String> getType = {12: '관광지', 14: '문화시설', 32: '숙박', 39: '음식점'};
