import 'dart:collection';
import 'package:offside/data/model/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offside/data/repository/chat_repository.dart';

//채팅 리스트 스트림
final chatListProvider =
    StreamProvider.autoDispose.family<Queue<Chat>, int>((ref, team) async* {
  final chatstream = chatRepositoryProvider.getChatStream(team: team)!;
  Queue<Chat> communityMSG = Queue();
  await for (QuerySnapshot<Object?> snapshot in chatstream) {
    for (var message in snapshot.docChanges) {
      if (message.type == DocumentChangeType.added) {
        communityMSG
            .add(Chat.fromJson(message.doc.data() as Map<String, dynamic>));
      } else {
        communityMSG.removeFirst();
      }
    }
    yield communityMSG;
  }
});

final chatViewModelProvider = Provider((ref) => ChatViewModel());

class ChatViewModel {
  Future<void> addChat(
      {required int team,
      required String text,
      required String uid,
      required String writer}) async {
    return chatRepositoryProvider.addChat(
        team: team, text: text, uid: uid, writer: writer);
  }
}
