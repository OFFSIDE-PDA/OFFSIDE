import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:offside/data/model/tour_model.dart';
import 'package:uuid/uuid.dart';

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
  var data = await getApi(lng, lat, type);
  List<TourModel> tourInfo = [];
  for (var value in data) {
    tourInfo.add(TourModel.fromMap(value));
  }
  return tourInfo;
}

//////////////////////////////////////////////////////////////////
//////////////////////////여행 일정 CRUD//////////////////////////

final firestore = FirebaseFirestore.instance;

Future<void> createTourPlan(String? uid, List selectedList, String date,
    int home, int away, String time) async {
  var planInfo = [];
  for (var item in selectedList) {
    planInfo.add({
      'addr': item.addr,
      'contentId': item.contentId,
      'typeId': item.typeId,
      'img': item.img,
      'title': item.title,
      'mapy': item.mapy,
      'mapx': item.mapx,
    });
  }

  await firestore
      .collection('users')
      .doc(uid)
      .collection("tour")
      .doc(const Uuid().v4())
      .set({
    date: {
      'tour': planInfo,
      'match': {'away': away, 'home': home, 'time': time}
    },
  });
}

Future<void> updateTourPlan(String? uid, List selectedList, String date,
    int home, int away, String time, String docUid) async {
  var planInfo = [];
  for (var item in selectedList) {
    planInfo.add({
      'addr': item['addr'],
      'contentId': item['contentId'],
      'typeId': item['typeId'],
      'img': item['img'],
      'title': item['title'],
      'mapy': item['mapy'],
      'mapx': item['mapx'],
    });
  }

  await firestore
      .collection('users')
      .doc(uid)
      .collection("tour")
      .doc(docUid)
      .set({
    date: {
      'tour': planInfo,
      'match': {'away': away, 'home': home, 'time': time}
    },
  });
}

Future<void> deleteTourPlan(String? uid, String docUid) async {
  await firestore
      .collection('users')
      .doc(uid)
      .collection("tour")
      .doc(docUid)
      .delete();
}
