import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offside/data/datasource/remote_data_source.dart';

final chatRepositoryProvider = ChatRepository();

class ChatRepository {
  late final ChatDataSource _chatDataSource = ChatDataSource();

  Future<void> addChat(
      {required String team,
      required String text,
      required String uid,
      required String writer}) async {
    return _chatDataSource.addChat(
        team: team, text: text, uid: uid, writer: writer);
  }

  Stream<QuerySnapshot<Object?>>? getChatStream({required String team}) {
    return _chatDataSource.getChatStream(team: team);
  }
}
