import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'dart:convert';

class MatchDataSource {
  final firestore = FirebaseFirestore.instance;

  ///`league`의 `year`년도 전체 경기를 조회
  Future<List<Map<String, dynamic>>> getLeagueMatches(
      int league, int year) async {
    List<Map<String, dynamic>> returnResult = [];
    QuerySnapshot<Map<String, dynamic>> result = await firestore
        .collection('match')
        .doc(year.toString())
        .collection("league$league")
        .orderBy("datetime")
        .get();

    for (QueryDocumentSnapshot docSnapshot in result.docs) {
      returnResult.add(docSnapshot.data() as Map<String, dynamic>);
    }

    return returnResult;
  }

  ///`league`의 `year`년도 전체 경기를 조회
  Future<Map<String, dynamic>?> getRecord(
      int league, int team1, int team2) async {
    DateTime dateTime = DateTime.now();
    int gameId = 0;
    QuerySnapshot<Map<String, dynamic>> result = await firestore
        .collection('match')
        .doc(dateTime.year.toString())
        .collection("league$league")
        .where("team1", isEqualTo: team1)
        .where("team2", isEqualTo: team2)
        .limit(1)
        .get();

    for (QueryDocumentSnapshot docSnapshot in result.docs) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      gameId = data["id"];
    }
    try {
      if (gameId != 0) {
        var response =
            await get(Uri.https('record-7trkcd7bvq-uc.a.run.app', '', {
          'year': dateTime.year.toString(),
          'league': league.toString(),
          'gameId': gameId.toString()
        }));
        var responseBody = jsonDecode(response.body);
        return responseBody;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
