import 'package:offside/data/datasource/remote_data_source.dart';
import 'package:offside/data/model/team_info.dart';

final teamInfoRepositoryProvider = TeamInfoRepository();

class TeamInfoRepository {
  final TeamInfoDataSource _teamInfoDataSource = TeamInfoDataSource();

  ///k리그1, 2의 모든 팀 정보 획득
  Future<List<TeamInfo>> getTeamInfo() async {
    List<Map<String, dynamic>> allTeamInfo =
        await _teamInfoDataSource.getTeamInfo();
    List<TeamInfo> teamsInfo = [
      TeamInfo()
    ]; //db에 저장된 팀id가 1부터 시작하기 때문에 더미클래스로 초기화
    List<Future<String>> logoUrlFutureList1 = [];
    List<Future<String>> stadiumUrlFutureList2 = [];

    for (Map<String, dynamic> teamInfo in allTeamInfo) {
      TeamInfo teaminfo = TeamInfo.fromMap(teamInfo);
      //로고 url, 주경기장 url 획득
      logoUrlFutureList1.add(_teamInfoDataSource
          .getTeamImg(teaminfo.fullName.replaceAll(" ", "")));
      stadiumUrlFutureList2.add(_teamInfoDataSource
          .getStadiumImg(teaminfo.fullName.replaceAll(" ", "")));

      teamsInfo.add(TeamInfo.fromMap(teamInfo));
    }
    //병렬로 url 획득
    List<String> imgUrlList =
        await Future.wait([...logoUrlFutureList1, ...stadiumUrlFutureList2]);
    List<String> logoUrlList = imgUrlList.sublist(0, imgUrlList.length ~/ 2);
    List<String> stadiumUrlList =
        imgUrlList.sublist(imgUrlList.length ~/ 2, imgUrlList.length);

    for (var i = 1; i < teamsInfo.length; i++) {
      teamsInfo[i].logoImg = logoUrlList[i - 1];
      teamsInfo[i].stadiumImg = stadiumUrlList[i - 1];
    }

    return teamsInfo;
  }
}
