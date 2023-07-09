import 'package:firebase_auth/firebase_auth.dart';
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
      required String team}) {
    return authRepositoryProvider
        .emailSignUp(email: email, password: password, nickname: nickname)
        .then((result) {
      _user = result;
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

  Future<void> updateTeam({required String team}) {
    return userInfoRepositoryProvider
        .updateMyTeam(uid: _user!.uid!, team: team)
        .then((result) {
      _user!.team = team;
      notifyListeners();
    });
  }

  Future<void> signIn() async {
    final tempUser = authRepositoryProvider.signIn();
    if (tempUser != null) {
      _user = tempUser;
      _user!.team =
          await userInfoRepositoryProvider.getMyTeam(uid: _user!.uid!);
      notifyListeners();
    }
  }

  Future signOut() {
    return authRepositoryProvider.signOut().then((result) {
      _user = null;
      notifyListeners();
    });
  }
}