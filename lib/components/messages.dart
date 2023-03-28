import 'package:chatflare/components/message_bubble.dart';
import 'package:chatflare/core/models/chat_message.dart';
import 'package:chatflare/core/services/auth/auth_service.dart';
import 'package:chatflare/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder<List<ChatMessage>>(
      stream: ChatService().messagesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Sem dados'),
          );
        } else {
          final msgs = snapshot.data!;
          return ListView.builder(
            reverse: true,
            itemCount: msgs.length,
            itemBuilder: (context, index) => MessageBubble(
              key: ValueKey(msgs[index].id),
              message: msgs[index],
              belongsToCurrentUser: currentUser?.id == msgs[index].userId,
            ),
          );
        }
      },
    );
  }
}
