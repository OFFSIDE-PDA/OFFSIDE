import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/model/match_model.dart';
import 'package:offside/data/repository/match_repository.dart';
import 'package:intl/intl.dart';

final matchViewModelProvider =
    ChangeNotifierProvider<MatchViewModel>((ref) => MatchViewModel());

///todo : data, time 을 기준으로 데이터 가공한 것을 datetime을 기준으로 변경
class MatchViewModel extends ChangeNotifier {
  Map<String, List<dynamic>>? _allMatchViewModel = {};
  Map<String, List<dynamic>>? get matchViewModel => _allMatchViewModel;

  Future<void> getAllMatches() async {
    var data =
        await matchDataRepositoryProvider.getAllMatches(DateTime.now().year);
    List<List<MatchModel>> kLeague1 = [];
    List<List<MatchModel>> kLeague2 = [];
    var lastDay = "";
    for (var e in data[0]) {
      lastDay = e['data'];
      if (kLeague1.isEmpty) {
        kLeague1.add([MatchModel.fromMap(e)]);
        lastDay = e['data'];
      } else {
        if (kLeague1.last[0].data == lastDay) {
          kLeague1.last.add(MatchModel.fromMap(e));
        } else {
          kLeague1.add([MatchModel.fromMap(e)]);
        }
      }
    }
    lastDay = "";
    for (var e in data[1]) {
      lastDay = e['data'];
      if (kLeague2.isEmpty) {
        kLeague2.add([MatchModel.fromMap(e)]);
        lastDay = e['data'];
      } else {
        if (kLeague2.last[0].data == lastDay) {
          kLeague2.last.add(MatchModel.fromMap(e));
        } else {
          kLeague2.add([MatchModel.fromMap(e)]);
        }
      }
    }

    List<List<MatchModel>> week1 = [];
    List<List<MatchModel>> week2 = [];
    List<dynamic> matches = [];
    int today = getToday();

    lastDay = "";
    for (int i = 0; i < data[0].length; i++) {
      if (week1.length == 5) {
        break;
      }
      var e = data[0][i];
      lastDay = e['data'];
      if (today > int.parse(lastDay)) {
        continue;
      }
      if (week1.isEmpty) {
        week1.add([MatchModel.fromMap(e)]);
        lastDay = e['data'];
      } else {
        if (week1.last[0].data == lastDay) {
          week1.last.add(MatchModel.fromMap(e));
        } else {
          week1.add([MatchModel.fromMap(e)]);
        }
      }
      matches.add([e['team1'], e['team2'], week1.length]);
    }

    lastDay = "";
    for (var i = 0; i < data[1].length; i++) {
      if (week2.length == 5) {
        break;
      }
      var e = data[1][i];
      lastDay = e['data'];
      if (today > int.parse(lastDay)) {
        continue;
      }
      if (week2.isEmpty) {
        week2.add([MatchModel.fromMap(e)]);
        lastDay = e['data'];
      } else {
        if (week2.last[0].data == lastDay) {
          week2.last.add(MatchModel.fromMap(e));
        } else {
          week2.add([MatchModel.fromMap(e)]);
        }
      }
      matches.add([e['team1'], e['team2'], e['data'], e['time'], e['score1'], e['score2'], week2.length]);
    }

    _allMatchViewModel = {
      'all': [kLeague1, kLeague2],
      'week': [week1, week2],
      'home': homeTeams(matches),
      'random': matches[today % matches.length]
    };
    notifyListeners();
  }

  getMatchDate() {
    var data1 = _allMatchViewModel?['all']?[0];
    var data2 = _allMatchViewModel?['all']?[1];
    Map<String, dynamic> k1 = {};
    Map<String, dynamic> k2 = {};
    var date = [];
    for (var item in data1) {
      var tmp = [];
      for (var element in item) {
        tmp.add(element);
      }
      k1[item[0].data] = tmp;
      date.add(item[0].data);
    }
    for (var item in data2) {
      var tmp = [];
      for (var element in item) {
        tmp.add(element);
      }
      k2[item[0].data] = tmp;
      date.add(item[0].data);
    }
    date = date.toSet().toList();
    date.sort();
    return {'date': date, 'k1': k1, 'k2': k2};
  }

  getWeekMatches(int league) {
    return _allMatchViewModel?['week']?[league - 1];
  }

  getLeagueLength(String type, int league) {
    return _allMatchViewModel?[type]?[league - 1].length;
  }

  getMatchIndex(String type, int league) {
    return _allMatchViewModel?[type]?[league - 1];
  }

  getHomeTeams() {
    return _allMatchViewModel?['home'];
  }

  isNull() {
    if (_allMatchViewModel == null) {
      return false;
    } else {
      return true;
    }
  }

  getRandomMatch() {
    return _allMatchViewModel?['random'];
  }

  homeTeams(List matches) {
    List<dynamic> tmp = [];
    for (var element in matches) {
      tmp.add(element[0]);
    }
    return tmp.toSet().toList();
  }

  getMyTeam(int teamIn) {
    List<List> myTeam = [];
    int win = 0;
    int draw = 0;
    int lose = 0;
    _allMatchViewModel?['all']?[0]?.forEach((value) {
      for (MatchModel e in value) {
        if (e.team1 == teamIn) {
          if (e.score1! > e.score2!) {
            myTeam.add([MatchModel.copy(e), 1]);
            win += 1;
          } else if (e.score1! < e.score2!) {
            myTeam.add([MatchModel.copy(e), 2]);
            lose += 1;
          } else {
            myTeam.add([MatchModel.copy(e), 3]);
            draw += 1;
          }
        } else if (e.team2 == teamIn) {
          if (e.score1! < e.score2!) {
            myTeam.add([MatchModel.copy(e), 1]);
            win += 1;
          } else if (e.score1! > e.score2!) {
            myTeam.add([MatchModel.copy(e), 2]);
            lose += 1;
          } else {
            myTeam.add([MatchModel.copy(e), 3]);
            draw += 1;
          }
        }
      }
    });
    _allMatchViewModel?['all']?[1]?.forEach((value) {
      for (MatchModel e in value) {
        if (e.team1 == teamIn) {
          if (e.score1! > e.score2!) {
            myTeam.add([MatchModel.copy(e), 1]);
            win += 1;
          } else if (e.score1! < e.score2!) {
            myTeam.add([MatchModel.copy(e), 2]);
            lose += 1;
          } else {
            myTeam.add([MatchModel.copy(e), 3]);
            draw += 1;
          }
        } else if (e.team2 == teamIn) {
          if (e.score1! < e.score2!) {
            myTeam.add([MatchModel.copy(e), 1]);
            win += 1;
          } else if (e.score1! > e.score2!) {
            myTeam.add([MatchModel.copy(e), 2]);
            lose += 1;
          } else {
            myTeam.add([MatchModel.copy(e), 3]);
            draw += 1;
          }
        }
      }
    });
    return {'team': myTeam, 'win': win, 'draw': draw, 'lose': lose};
  }

  getFilteredTeams(int league, int selectedTeam) {
    List<MatchModel> team = [];
    for (List<MatchModel> matches in _allMatchViewModel?['all']?[league - 1]) {
      for (MatchModel match in matches) {
        if (match.team1 == selectedTeam || match.team2 == selectedTeam) {
          team.add(match);
        }
      }
    }
    return team;
  }

  getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyMMdd');
    return int.parse(formatter.format(now));
  }

  Future<List<RecordModel>> getRecord(int league, int team1, int team2) async {
    return await matchDataRepositoryProvider.getRecord(league, team1, team2);
  }
}
