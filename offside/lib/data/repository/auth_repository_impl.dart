import 'package:firebase_auth/firebase_auth.dart';
import 'package:offside/data/repository/auth_repository.dart';
import 'package:offside/data/model/app_user.dart';
import 'package:offside/data/datasource/remote_data_source.dart';

final authRepositoryProvider = AuthRepositoryImpl();

class AuthRepositoryImpl implements AuthRepository {
  late final AuthDataSource _dataSource = AuthDataSource();

  @override
  Future<AppUser> kakaoSignIn() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return AppUser.fromUser(await _dataSource.kakaoSignIn());
    }
    return AppUser.fromUser(FirebaseAuth.instance.currentUser!);
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }

  @override
  Future<AppUser> emailSignUp(
      {required String email, required String password}) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return AppUser.fromUser(await _dataSource.emailSignUp(
        email: email,
        password: password,
      ));
    }
    return AppUser.fromUser(FirebaseAuth.instance.currentUser!);
  }

  @override
  Future<AppUser> emailSignIn(
      {required String email, required String password}) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return AppUser.fromUser(await _dataSource.emailSignIn(
        email: email,
        password: password,
      ));
    }
    return AppUser.fromUser(FirebaseAuth.instance.currentUser!);
  }
}
