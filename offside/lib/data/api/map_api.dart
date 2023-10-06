import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<List> getRoute(startx, starty, destx, desty) async {
  const String apiUrl =
      "https://apis-navi.kakaomobility.com/v1/waypoints/directions";
  const String restApiKey = "9b39d69c59df2f93e51f3dd3754b7b9c";
  if (await Permission.location.isGranted) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    starty = position.latitude;
    startx = position.longitude;
  }
  if (await Permission.location.isDenied) {
    print('location denied');
    openAppSettings();
  }

  List points = [];
  final Map<String, dynamic> requestData = {
    "origin": {"x": startx, "y": starty},
    "destination": {"x": destx, "y": desty}
  };
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "KakaoAK $restApiKey",
    },
    body: json.encode(requestData),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));

    for (var item in data["routes"][0]["sections"]) {
      for (var value in item["guides"]) {
        points.add({'y': value['y'], 'x': value['x']});
      }
    }
    return points;
  } else {
    print('error');
  }
  return points;
}

Future<List> sendPostRequest(List selectedList, destx, desty) async {
  const String apiUrl =
      "https://apis-navi.kakaomobility.com/v1/waypoints/directions";
  const String restApiKey = "9b39d69c59df2f93e51f3dd3754b7b9c";
  var wayPoints = [];
  for (var item in selectedList) {
    wayPoints.add({"name": item.title, "x": item.mapx, "y": item.mapy});
  }
  List result = [];
  for (var item in [1, 3, 7]) {
    final Map<String, dynamic> requestData = {
      "origin": {"x": "127.11024293202674", "y": "37.394348634049784"},
      "destination": {"x": destx, "y": desty},
      "waypoints": wayPoints,
      "priority": "RECOMMEND",
      "car_type": item
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "KakaoAK $restApiKey",
      },
      body: json.encode(requestData),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int time = data["routes"][0]["summary"]["duration"];
      int hour = time ~/ 60 ~/ 60;
      int min = time ~/ 60 % 60;
      if (hour == 0) {
        result.add("$min분");
      } else {
        result.add("$hour시간 $min분");
      }
    }
  }
  return result;
}
