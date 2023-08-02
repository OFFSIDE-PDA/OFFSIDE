import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  Chat(Map data, {this.text, this.time, this.uid, this.writer});

  Chat.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    time = json['time'];
    uid = json['uid'];
    writer = json['writer'];
  }

  String? text;
  Timestamp? time;
  String? uid;
  String? writer;
}
