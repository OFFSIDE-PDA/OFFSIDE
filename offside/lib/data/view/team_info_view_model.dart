import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/model/team_info.dart';
import 'package:offside/data/repository/team_info_repository.dart';
import 'package:flutter/foundation.dart';

final teamInfoViewModelProvider =
    ChangeNotifierProvider<TeamInfoViewModel>((ref) => TeamInfoViewModel());

class TeamInfoViewModel extends ChangeNotifier {
  List<TeamInfo> _teamInfoList = [];

  List<TeamInfo> get teamInfoList => _teamInfoList;

  Future<void> getTeamInfo() async {
    _teamInfoList = await teamInfoRepositoryProvider.getTeamInfo();
    notifyListeners();
  }
}
