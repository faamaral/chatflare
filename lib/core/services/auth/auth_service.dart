import 'dart:io';

import 'package:chatflare/core/models/chatflare_user.dart';

abstract class AuthService {
  ChatflareUser? get currentUser;

  Stream<ChatflareUser?> get userChanges;

  Future<void> signup(String nome, String email, String password, File image);
  Future<void> login(String email, String password);
  Future<void> logout();
}
