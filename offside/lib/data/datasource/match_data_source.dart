import 'package:cloud_firestore/cloud_firestore.dart';

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
}
