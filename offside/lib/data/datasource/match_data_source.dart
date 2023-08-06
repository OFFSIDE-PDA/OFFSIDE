import 'package:cloud_firestore/cloud_firestore.dart';

class MatchDataSource {
  final firestore = FirebaseFirestore.instance;

  Future<List> getAllMatches() async {
    final firestore = FirebaseFirestore.instance;
    var k1Result = await firestore.collection('match').doc('kLeague1').get();
    var k2Result = await firestore.collection('match').doc('kLeague2').get();
    return [k1Result.data()?['match'], k2Result.data()?['match']];
  }
}
