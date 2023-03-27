import 'package:chatflare/core/models/chatflare_user.dart';
import 'package:chatflare/core/services/auth/auth_mock_service.dart';
import 'package:chatflare/pages/auth_page.dart';
import 'package:chatflare/pages/chat_page.dart';
import 'package:chatflare/pages/loading_page.dart';
import 'package:flutter/material.dart';

import '../core/services/auth/auth_service.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChatflareUser?>(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            return snapshot.hasData ? const ChatPage() : const AuthPage();
          }
        },
      ),
    );
  }
}
