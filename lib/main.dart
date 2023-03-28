import 'package:chatflare/core/services/notification/chat_notification_service.dart';
import 'package:chatflare/pages/auth_or_app_page.dart';
import 'package:chatflare/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatNoticationService(),)
      ],
      child: MaterialApp(
        title: 'ChatFlare',
        theme: ThemeData(
          
          primarySwatch: Colors.blue,
        ),
        home: AuthOrAppPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
