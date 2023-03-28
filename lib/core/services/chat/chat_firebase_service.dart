import 'dart:async';
import 'dart:math';

import 'package:chatflare/core/models/chat_message.dart';
import 'package:chatflare/core/services/chat/chat_service.dart';
import 'package:chatflare/utils/constants/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chatflare_user.dart';

class ChatFirebaseService implements ChatService {
  Stream<List<ChatMessage>> messagesStream() {
    return Stream<List<ChatMessage>>.empty();
  }

  Future<ChatMessage?> save(String text, ChatflareUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = await store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': user.id,
      'userName': user.name,
      'userImageUrl': user.imageUrl,
    });

    final doc = await docRef.get();
    final data = doc.data()!;
    return ChatMessage(
      id: doc.id,
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt']),
      userId: data['userId'],
      userName: data['userName'],
      userImageUrl: data['userImageUrl'],
    );
  }
}
