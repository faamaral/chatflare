import 'package:chatflare/core/models/chat_notification.dart';
import 'package:flutter/material.dart';

class ChatNoticationService with ChangeNotifier {
  List<ChatNotification> _items = [];
  List<ChatNotification> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int index) {
    _items.removeAt(index);
  }
}
