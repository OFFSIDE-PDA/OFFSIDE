import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offside/data/datasource/match_data_source.dart';
import 'package:intl/intl.dart';
import 'package:offside/data/model/match_model.dart';

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

  ///`year` 년도의 모든 k리그 1,2 경기 획득
  Future<List<RecordModel>> getRecord(int league, int team1, int team2) async {
    Map<String, dynamic>? result =
        await _matchDataSource.getRecord(1, team1, team2);

    //TODO : 함수 호출할때 알맞은 리그값 넘겨받도록 호출부에서 변경
    List<RecordModel> recordData = [];
    if (!result.isNull) {
      recordData.add(RecordModel.fromMap(result!["total"]));
      recordData.add(RecordModel.fromMap(result["recent"]));
    } else {
      Map<String, dynamic>? result1 =
          await _matchDataSource.getRecord(2, team1, team2);
      if (!result1.isNull) {
        recordData.add(RecordModel.fromMap(result!["total"]));
        recordData.add(RecordModel.fromMap(result["recent"]));
      } else {
        recordData.add(RecordModel(0, 0, 0));
        recordData.add(RecordModel(0, 0, 0));
      }
    }

    return recordData;
  }
}
