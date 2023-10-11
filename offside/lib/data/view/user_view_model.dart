import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/model/app_user.dart';
import 'package:offside/data/repository/auth_repository.dart';
import 'package:offside/data/repository/user_info_repository.dart';
import 'package:flutter/foundation.dart';

final userViewModelProvider =
    ChangeNotifierProvider<UserViewModel>((ref) => UserViewModel());

class UserViewModel extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> kakaoSignIn() {
    return authRepositoryProvider.kakaoSignIn().then((result) async {
      _user = result;
      try {
        _user!.team =
            await userInfoRepositoryProvider.getMyTeam(uid: _user!.uid!);
      } catch (e) {
        //처음 카카오 로그인
      }
      notifyListeners();
    });
  }

  Future<void> emailSignUp(
      {required String email,
      required String password,
      required String nickname,
      required int team}) {
    return authRepositoryProvider
        .emailSignUp(email: email, password: password, nickname: nickname)
        .then((result) {
      _user = result;
      _user!.nickname = nickname;
      userInfoRepositoryProvider.updateMyTeam(uid: _user!.uid!, team: team);
      _user!.team = team;
      notifyListeners();
    });
  }

  Future<void> emailSignIn({required String email, required String password}) {
    return authRepositoryProvider
        .emailSignIn(
      email: email,
      password: password,
    )
        .then((result) async {
      _user = result;
      _user!.team =
          await userInfoRepositoryProvider.getMyTeam(uid: _user!.uid!);
      notifyListeners();
    });
  }

  Future<void> updateTeam({required int team}) async {
    return await userInfoRepositoryProvider
        .updateMyTeam(uid: _user!.uid!, team: team)
        .then((result) {
      _user!.team = team;
      notifyListeners();
    });
  }

  bool autoSignIn() {
    final tempUser = authRepositoryProvider.autoSignIn();
    if (tempUser != null) {
      _user = tempUser;
      userInfoRepositoryProvider.getMyTeam(uid: _user!.uid!).then((value) {
        _user!.team = value;
        notifyListeners();
      });
      return true;
    } else {
      return false;
    }
  }

  //TODO : 웹 환경에서도 로그아웃 구현
  Future signOut() {
    return authRepositoryProvider.signOut().then((result) {
      _user = null;
      notifyListeners();
      SystemNavigator.pop();
    });
  }

  ///비밀번호 재설정 이메일 보내기
  Future<void> sendPasswordResetEmail({required String email}) async {
    await authRepositoryProvider.sendPasswordResetEmail(email: email);
  }

  ///비밀번호 재설정
  Future<void> updatePassword({required String newPassword}) async {
    await authRepositoryProvider.updatePassword(newPassword: newPassword);
  }

  ///유저 정보 업데이트
  Future<void> updateUserInfo(
      {required String uid,
      required String email,
      required String nickname,
      required int team}) async {
    await authRepositoryProvider.updateUserInfo(
        email: email, nickname: nickname);
    _user!.email = email;
    _user!.nickname = nickname;
    await userInfoRepositoryProvider.updateMyTeam(uid: uid, team: team);
    _user!.team = team;
    notifyListeners();
  }

  Future<Map> getMyTour({required String? uid}) async {
    return await userInfoRepositoryProvider.getMyTour(uid: uid!);
  }

  Future<void> accountCancellation() async {
    await authRepositoryProvider
        .accountCancellation()
        .then((value) => SystemNavigator.pop());
  }
}
