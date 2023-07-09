import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'package:http/http.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class remoteDataSource {
  ///네트워크 연결 확인
  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}

///인증에 관련된 외부데이터소스
class AuthDataSource extends remoteDataSource {
  ///카카오를 통한 간편로그인
  Future<User> kakaoSignIn() async {
    if (!await checkNetwork()) {
      throw Exception("인터넷 연결 없음");
    }
    try {
      //이미 존재하는 연결된 카카오 계정이 있는지 확인
      Kakao.User user = await Kakao.UserApi.instance.me();
    } catch (e) {
      //연결된 카카오 계정이 없다면 카카오 로그인
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
              throw Exception("카카오 인증 실패");
            }
          }
        } else {
          try {
            await Kakao.UserApi.instance.loginWithKakaoAccount();
            print('카카오계정으로 로그인 성공 3');
          } catch (error) {
            print('카카오계정으로 로그인 실패 3 $error');
            throw Exception("카카오 인증 실패");
          }
        }
      } else {
        print('$e');
        throw Exception("카카오 인증 실패");
      }
    }
    Kakao.User user = await Kakao.UserApi.instance.me();

    //파이어베이스에 카카오 인증 uid를 통해 계정 생성
    var response =
        await get(Uri.http('localhost:8000', '/', {'id': user.id.toString()}));
    var responseBody = response.body;
    final userCredential = await FirebaseAuth.instance
        .signInWithCustomToken(responseBody.toString());
    final realUser = userCredential.user;
    //첫 카카오를 통한 로그인이라면 파이어베이스 계정 정보 초기화
    if (realUser?.displayName == null && realUser?.photoURL == null) {
      await realUser?.updateDisplayName(user.kakaoAccount!.profile!.nickname);
      await realUser
          ?.updatePhotoURL(user.kakaoAccount!.profile!.profileImageUrl);
    }
    return realUser!;
  }

  ///로그아웃
  ///로컬에 저장된 카카오 로그인 정보와 파이버베이스 로그인 정보 삭제
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

  ///이메일 회원가입
  Future<User> emailSignUp(
      {required String email,
      required String password,
      required String nickname}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(nickname);
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
    throw Exception("이메일 회원가입 실패");
  }

  ///이메일 로그인
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
    throw Exception("이메일 로그인 실패");
  }
}

///인증정보를 제외한 유저 정보에 관련된 외부데이터소스
class UserInfoDataSource {
  ///응원팀 생성 및 업데이트
  Future<bool> updateMyTeam({required String uid, required String team}) async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("users").doc(uid).set({"team": team});
    } catch (e) {
      print("응원팀 업데이트 오류");
      return false;
    }
    return true;
  }

  ///응원팀 조회
  Future<String> getMyTeam({required String uid}) async {
    final db = FirebaseFirestore.instance;
    DocumentSnapshot teamDoc = await db.collection("users").doc(uid).get();
    Map data = teamDoc.data() as Map<String, dynamic>;

    return data["team"];
  }
}
