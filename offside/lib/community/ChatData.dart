import 'package:flutter/cupertino.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  String nickname;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.nickname});
}
