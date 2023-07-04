import 'package:offside/data/model/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> kakaoSignIn();

  Future<void> signOut();

  Future<AppUser> emailSignUp(
      {required String email, required String password});

  Future<AppUser> emailSignIn(
      {required String email, required String password});
}
