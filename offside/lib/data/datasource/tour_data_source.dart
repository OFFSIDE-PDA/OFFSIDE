import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// String encondingKey =
//     "4cLVOervdUDMVZg9nQde%2FY99WAtbEexyIhfSUAZEi04RhOZBXkLWHextf%2F4fT1TZtzclmylXmC7Y%2BZI5mrNq1g%3D%3D";

String encodingKey =
    '4cLVOervdUDMVZg9nQde%2FY99WAtbEexyIhfSUAZEi04RhOZBXkLWHextf%2F4fT1TZtzclmylXmC7Y%2BZI5mrNq1g%3D%3D';
String url = "http://apis.data.go.kr/B551011/KorService1/locationBasedList1";
String queryParams1 = "?serviceKey=$encodingKey";

class TourDataSource {
  Future<Map<String, dynamic>> getTourData() async {
    Map<String, dynamic> data = {};
    teams.forEach((key, value) async {
      String teamName = key;
      var stadium = value['stadium'];
      var mapX = value['mapX'];
      var mapY = value['mapY'];

      final resTour = await getApi(mapX, mapY, 12);
      print(resTour);
      // final resCulture = await getApi(mapX, mapY, 14);
      // final resHotel = await getApi(mapX, mapY, 32);
      // final resFood = await getApi(mapX, mapY, 39);
      data[teamName] = {
        'tour': resTour,
        // 'culture': resCulture,
        // 'hotel': resHotel,
        // 'food': resFood
      };
    });
    // print(data);
    return data;
  }

//https://apis.data.go.kr/B551011/KorService1/locationBasedList1?serviceKey=4cLVOervdUDMVZg9nQde%2FY99WAtbEexyIhfSUAZEi04RhOZBXkLWHextf%2F4fT1TZtzclmylXmC7Y%2BZI5mrNq1g%3D%3D&MobileOS=AND&MobileApp=AppTest&_type=JSON&listYN=Y&arrange=A&mapX=128.0862916&mapY=36.1395332&radius=5000&contentTypeId=12
  getApi(Object? mapX, Object? mapY, int type) async {
    String queryParams2 =
        "&numOfRows=5&MobileOS=AND&MobileApp=Offside&_type=json&mapX=$mapX&mapY=$mapY&radius=50000&contentTypeId=$type";
    final response = await http
        .get(Uri.parse(url + queryParams1 + queryParams2))
        .then((value) {
      if (value.statusCode == 200) {
        final data = utf8.decode(value.bodyBytes);
        print('adsfadsf $data');
        return data;
      } else {}
    });

    // print('......................................\n');
    // print(utf8.decode(response.bodyBytes));
    // if (response.statusCode == 200) {
    //var data = jsonDecode(utf8.decode(response.bodyBytes));
    // Map<String, dynamic> data = jsonDecode(response.body);
    // var data = utf8.decode(response.bodyBytes);
    // return data['response']['body']['items'];
    // } else {
    //   throw Exception('Failed to load data');
    // }
    return null;
  }
}

var teams = {
  '울산 현대': {'stadium': '울산 문수', 'mapX': 129.2595839, 'mapY': 35.5352422},
  // '포항 스틸러스': {'stadium': '포항 스틸야드', 'mapX': 129.3844018, 'mapY': 35.9977189},
  // 'FC 서울': {'stadium': '서울 월드컵', 'mapX': 126.8974467, 'mapY': 37.5669459},
  // '전북 현대 모터스': {'stadium': '전주 월드컵', 'mapX': 127.0644156, 'mapY': 35.8681258},
  // '광주 FC': {'stadium': '광주 전용', 'mapX': 126.8749636, 'mapY': 35.1309926},
  // '대전 하나 시티즌': {'stadium': '대전 월드컵', 'mapX': 127.324859, 'mapY': 36.3652954},
  // '대구 FC': {'stadium': 'DGB대구은행파크', 'mapX': 128.5882175, 'mapY': 35.8812441},
  // '인천 유나이티드': {'stadium': '인천 전용', 'mapX': 126.6430109, 'mapY': 37.4660127},
  // '제주 유나이티드': {'stadium': '제주 월드컵', 'mapX': 126.5093244, 'mapY': 33.2461852},
  // '수원 FC': {'stadium': '수원 종합', 'mapX': 127.0113456, 'mapY': 37.297749},
  // '수원 삼성 블루윙즈': {'stadium': '수원 월드컵', 'mapX': 127.036866, 'mapY': 37.2864742},
  // '강원 FC': {'stadium': '강릉 종합', 'mapX': 128.8973227, 'mapY': 37.7732204},
  // '강원': {'stadium': '춘천 송암', 'mapX': 127.6908785, 'mapY': 37.8557132},
  // '김천 상무 FC': {'stadium': '김천 종합', 'mapX': 128.0862916, 'mapY': 36.1395332},
  // '경남 FC': {'stadium': '창원 축구센터', 'mapX': 128.7057262, 'mapY': 35.2234132},
  // '부산 아이파크': {'stadium': '부산 아시아드', 'mapX': 129.0582686, 'mapY': 35.1899786},
  // '김포 FC': {'stadium': '김포솔터축구장', 'mapX': 126.6499501, 'mapY': 37.6408207},
  // 'FC 안양': {'stadium': '안양 종합', 'mapX': 126.946422, 'mapY': 37.405304},
  // '부천 FC 1995': {'stadium': '부천 종합', 'mapX': 126.7988895, 'mapY': 37.5024816},
  // '전남 드래곤즈': {'stadium': '광양 전용', 'mapX': 127.7274752, 'mapY': 34.9331001},
  // '성남 FC': {'stadium': '탄천 종합', 'mapX': 127.1204089, 'mapY': 37.410118},
  // '충북 청주 FC': {'stadium': '청주 종합', 'mapX': 127.4723234, 'mapY': 36.6378563},
  // '충남 아산 FC': {'stadium': '아산 이순신', 'mapX': 127.0212148, 'mapY': 36.7681453},
  // '서울 이랜드 FC': {'stadium': '목동 종합', 'mapX': 126.8830404, 'mapY': 37.5305581},
  // '안산 그리너스 FC': {
  //   'stadium': '안산 와스타디움',
  //   'mapX': 126.8187791,
  //   'mapY': 37.3196898
  // },
  // '천안 시티 FC': {'stadium': '천안 종합', 'mapX': 127.115144, 'mapY': 36.818712},
};
