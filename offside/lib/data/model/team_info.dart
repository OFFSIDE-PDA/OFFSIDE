import 'package:cloud_firestore/cloud_firestore.dart';

class TeamInfo {
  TeamInfo();

  TeamInfo.fromMap(Map<String, dynamic> map) {
    city = map["city"];
    color = map["color"];
    founded = map["founded"];
    fullName = map["full_name"];
    middleName = map["middle_name"];
    league = map["league"];
    name = map["name"];
    site = map["site"];
    stadium = map["stadium"];
    stadiumGeo = map["stadium_geo"];
  }

  String city = "dummy";
  List color = [];
  Timestamp founded = Timestamp(0, 0);
  String fullName = "dummy";
  int league = 0;
  String name = "dummy";
  String site = "dummy";
  String stadium = "dummy";
  GeoPoint stadiumGeo = const GeoPoint(0.0, 0.0);
  String stadiumImg = "dummy";
  String logoImg = "dummy";
  int id = 0;
  String middleName = "dummy";
}
