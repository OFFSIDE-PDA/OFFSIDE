import 'package:firebase_auth/firebase_auth.dart';
import 'package:offside/data/model/app_user.dart';
import 'package:offside/data/datasource/remote_data_source.dart';

final authRepositoryProvider = AuthRepository();

class AuthRepository {
  late final AuthDataSource _authDataSource = AuthDataSource();

  Future<AppUser> kakaoSignIn() async {
    return AppUser.fromUser(await _authDataSource.kakaoSignIn());
  }

  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  AppUser? signIn() {
    print("인증 레파지토리 로그인 호출");
    if (FirebaseAuth.instance.currentUser != null) {
      return AppUser.fromUser(FirebaseAuth.instance.currentUser!);
    }
    print("자동 로그인 실패");
    return null;
  }

  Future<AppUser> emailSignUp(
      {required String email,
      required String password,
      required String nickname}) async {
    return AppUser.fromUser(await _authDataSource.emailSignUp(
        email: email, password: password, nickname: nickname));
  }

  Future<AppUser> emailSignIn(
      {required String email, required String password}) async {
    return AppUser.fromUser(await _authDataSource.emailSignIn(
      email: email,
      password: password,
    ));
  }
}
