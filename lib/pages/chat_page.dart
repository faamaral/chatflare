import 'dart:math';

import 'package:chatflare/components/messages.dart';
import 'package:chatflare/components/new_message.dart';
import 'package:chatflare/core/models/chat_notification.dart';
import 'package:chatflare/core/services/notification/chat_notification_service.dart';
import 'package:chatflare/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/auth/auth_service.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatflare'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ),
              ],
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                  ),
                ),
                icon: const Icon(Icons.notifications),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: Colors.red.shade800,
                  child: Text(
                    '${Provider.of<ChatNoticationService>(context).itemsCount}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () =>
      //       Provider.of<ChatNoticationService>(context, listen: false)
      //           .add(ChatNotification(title: 'Teste', body: Random().nextDouble().toString())),
      //   child: Icon(Icons.message),
      // ),
    );
  }
}
