import 'package:offside/data/datasource/match_data_source.dart';

final matchDataRepositoryProvider = MatchDataRepository();

class MatchDataRepository {
  late final MatchDataSource _matchDataSource = MatchDataSource();

  Future<List> getAllMatches() async {
    return await _matchDataSource.getAllMatches();
  }
}
