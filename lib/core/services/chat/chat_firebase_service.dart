import 'dart:async';
import 'dart:math';

import 'package:chatflare/core/models/chat_message.dart';
import 'package:chatflare/core/services/chat/chat_service.dart';
import 'package:chatflare/utils/constants/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chatflare_user.dart';

class ChatFirebaseService implements ChatService {
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Stream<List<ChatMessage>>.multi(
      (controller) {
        snapshots.listen((snapshot) {
          List<ChatMessage> list = snapshot.docs.map((doc) => doc.data()).toList();
          controller.add(list);
        });
      },
    );
  }

  Future<ChatMessage?> save(String text, ChatflareUser user) async {
    final store = FirebaseFirestore.instance;
    final msg = ChatMessage(
        id: '',
        text: text,
        createdAt: DateTime.now(),
        userId: user.id,
        userName: user.name,
        userImageUrl: user.imageUrl);
    final docRef = await store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(msg);

    final doc = await docRef.get();
    return doc.data()!;
  }

  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? options) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageUrl': msg.userImageUrl,
    };
  }

  ChatMessage _fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageUrl: doc['userImageUrl'],
    );
  }
}
