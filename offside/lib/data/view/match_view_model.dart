import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/model/match_model.dart';
import 'package:offside/data/repository/match_repository.dart';
import 'package:intl/intl.dart';

final matchViewModelProvider =
    ChangeNotifierProvider<MatchViewModel>((ref) => MatchViewModel());

class MatchViewModel extends ChangeNotifier {
  Map<String, List<dynamic>>? _allMatchViewModel;
  Map<String, List<dynamic>>? get matchViewModel => _allMatchViewModel;

  void getAllMatches() async {
    var data = await matchDataRepositoryProvider.getAllMatches();
    List<List> kLeague1 = [];
    List<List> kLeague2 = [];
    var lastDay = "";
    data[0].forEach((dynamic e) {
      lastDay = e['data'];
      if (kLeague1.isEmpty) {
        kLeague1.add([
          MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
              e['location'], e['time'], e['score1'])
        ]);
        lastDay = e['data'];
      } else {
        if (kLeague1.last[0].data == lastDay) {
          kLeague1.last.add(MatchModel(e['data'], e['score2'], e['team1'],
              e['team2'], e['location'], e['time'], e['score1']));
        } else {
          kLeague1.add([
            MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
                e['location'], e['time'], e['score1'])
          ]);
        }
      }
    });
    lastDay = "";
    data[1].forEach((dynamic e) {
      lastDay = e['data'];
      if (kLeague2.isEmpty) {
        kLeague2.add([
          MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
              e['location'], e['time'], e['score1'])
        ]);
        lastDay = e['data'];
      } else {
        if (kLeague2.last[0].data == lastDay) {
          kLeague2.last.add(MatchModel(e['data'], e['score2'], e['team1'],
              e['team2'], e['location'], e['time'], e['score1']));
        } else {
          kLeague2.add([
            MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
                e['location'], e['time'], e['score1'])
          ]);
        }
      }
    });

    List<List> week1 = [];
    List<List> week2 = [];
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
        week1.add([
          MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
              e['location'], e['time'], e['score1'])
        ]);
        lastDay = e['data'];
      } else {
        if (week1.last[0].data == lastDay) {
          week1.last.add(MatchModel(e['data'], e['score2'], e['team1'],
              e['team2'], e['location'], e['time'], e['score1']));
        } else {
          week1.add([
            MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
                e['location'], e['time'], e['score1'])
          ]);
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
        week2.add([
          MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
              e['location'], e['time'], e['score1'])
        ]);
        lastDay = e['data'];
      } else {
        if (week2.last[0].data == lastDay) {
          week2.last.add(MatchModel(e['data'], e['score2'], e['team1'],
              e['team2'], e['location'], e['time'], e['score1']));
        } else {
          week2.add([
            MatchModel(e['data'], e['score2'], e['team1'], e['team2'],
                e['location'], e['time'], e['score1'])
          ]);
        }
      }
      matches.add([e['team1'], e['team2'], week2.length]);
    }

    var home = homeTeams(matches);

    _allMatchViewModel = {
      'all': [kLeague1, kLeague2],
      'week': [week1, week2],
      'home': home,
      'random': matches[today % matches.length]
    };
    notifyListeners();
  }

  getWeekMatches(int league) {
    return _allMatchViewModel?['week']?[league - 1];
  }

  getLeagueLength(String type, int league) {
    return _allMatchViewModel?[type]?[league - 1].length;
  }

  getMatchIndex(String type, int league, int index) {
    return _allMatchViewModel?[type]?[league - 1][index];
  }

  getHomeTeams() {
    return _allMatchViewModel?['home'];
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

  getFilteredTeams(int league, String selectedTeam) {
    var team = [];
    for (var matches in _allMatchViewModel?['all']?[league - 1]) {
      for (var match in matches) {
        if (match.getTeam1() == selectedTeam ||
            match.getTeam2() == selectedTeam) {
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
}
