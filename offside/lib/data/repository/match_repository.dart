import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offside/data/datasource/match_data_source.dart';
import 'package:intl/intl.dart';

final matchDataRepositoryProvider = MatchDataRepository();

class MatchDataRepository {
  final MatchDataSource _matchDataSource = MatchDataSource();

  ///`year` 년도의 모든 k리그 1,2 경기 획득
  Future<List<List<Map<String, dynamic>>>> getAllMatches(int year) async {
    List<List<Map<String, dynamic>>> result = await Future.wait([
      _matchDataSource.getLeagueMatches(1, year),
      _matchDataSource.getLeagueMatches(2, year)
    ]);

    //임시로 데이터 변환
    //todo : 데이터 변환없이 datetime으로 view_model조작할 수 있도록 변경
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < result[i].length; j++) {
        Timestamp timestamp = result[i][j]["datetime"];
        DateTime dt = timestamp.toDate().subtract(const Duration(hours: 9));
        String data = DateFormat("yyMMdd").format(dt);
        String time = DateFormat("hhmm").format(dt);

        result[i][j]["data"] = data;
        result[i][j]["time"] = time;
      }
    }
    return result;
  }
}
