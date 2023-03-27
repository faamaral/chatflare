import 'package:chatflare/core/models/chat_message.dart';
import 'package:chatflare/core/models/chatflare_user.dart';
import 'package:chatflare/core/services/chat/chat_mock_service.dart';

abstract class ChatService {
  Stream<List<ChatMessage>> messagesStream();
  Future<ChatMessage> save(String text, ChatflareUser user);

  factory ChatService() {
    return ChatMockService();
  }
}
