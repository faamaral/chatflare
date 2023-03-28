import 'package:chatflare/core/services/notification/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChatNoticationService>(context);
    final items = service.items;
    return Scaffold(
        appBar: AppBar(
          title: Text('Notificações'),
        ),
        body: ListView.builder(
          itemCount: service.itemsCount,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index].title),
            subtitle: Text(items[index].body),
            onTap: () => service.remove(index),
          ),
        ));
  }
}