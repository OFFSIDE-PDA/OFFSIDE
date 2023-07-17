import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  AppUser({this.uid, this.nickname, this.imageUrl, this.email, this.team});

  factory AppUser.fromJson(Map<String, String> json) {
    return AppUser(
        uid: json['uid'],
        nickname: json['nickname'],
        imageUrl: json['imageUrl'],
        email: json['email'],
        team: json['team']);
  }

  factory AppUser.fromUser(User user) {
    return AppUser(
        uid: user.uid,
        nickname: user.displayName,
        imageUrl: user.photoURL,
        email: user.email);
  }

  String? uid;
  String? nickname;
  String? imageUrl;
  String? email;
  String? team;
}
