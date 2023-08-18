import 'package:firebase_auth/firebase_auth.dart';
import 'package:offside/data/repository/auth_repository.dart';
import 'package:offside/data/model/app_user.dart';
import 'package:offside/data/datasource/remote_data_source.dart';

final userInfoRepositoryProvider = UserInfoRepository();

class UserInfoRepository {
  final UserInfoDataSource _userInfoDataSource = UserInfoDataSource();

  Future<int> getMyTeam({required String uid}) async {
    return await _userInfoDataSource.getMyTeam(uid: uid);
  }

  Future<bool> updateMyTeam({required String uid, required int team}) async {
    return await _userInfoDataSource.updateMyTeam(uid: uid, team: team);
  }
}
