import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'package:http/http.dart';

class AuthDataSource {
  Future<User> kakaoSignIn() async {
    try {
      Kakao.User user = await Kakao.UserApi.instance.me();
    } catch (e) {
      if (e is Kakao.KakaoClientException) {
        print("카카오 로그인 필요");
        // 카카오톡 실행 가능 여부 확인
        // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
        if (await Kakao.isKakaoTalkInstalled()) {
          try {
            await Kakao.UserApi.instance.loginWithKakaoTalk(); //카톡으로 로그인
            print('카카오톡으로 로그인 성공 1');
          } catch (error) {
            print('카카오톡으로 로그인 실패 1 $error');

            // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
            // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
            // if (error is PlatformException && error.code == 'CANCELED') {
            //   return;
            // }
            // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
            try {
              await Kakao.UserApi.instance.loginWithKakaoAccount();
              print('카카오계정으로 로그인 성공 2');
            } catch (error) {
              print('카카오계정으로 로그인 실패 2 $error');
              throw Exception("signin-fail");
            }
          }
        } else {
          try {
            await Kakao.UserApi.instance.loginWithKakaoAccount();
            print('카카오계정으로 로그인 성공 3');
          } catch (error) {
            print('카카오계정으로 로그인 실패 3 $error');
            throw Exception("signin-fail");
          }
        }
      } else {
        print('$e');
        throw Exception("signin-fail");
      }
    }
    Kakao.User user = await Kakao.UserApi.instance.me();
    var response =
        await get(Uri.http('localhost:8000', '/', {'id': user.id.toString()}));
    var responseBody = response.body;
    final userCredential = await FirebaseAuth.instance
        .signInWithCustomToken(responseBody.toString());
    final realUser = userCredential.user;
    if (realUser?.displayName == null && realUser?.photoURL == null) {
      await realUser?.updateDisplayName(user.kakaoAccount!.profile!.nickname);
      await realUser
          ?.updatePhotoURL(user.kakaoAccount!.profile!.profileImageUrl);
    }
    return realUser!;
  }

  Future<void> signOut() async {
    try {
      try {
        await Kakao.UserApi.instance.logout();
      } catch (e) {}
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<User> emailSignUp(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    throw Exception("signup-fail");
  }

  Future<User> emailSignIn(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    throw Exception("signin-fail");
  }
}
