import 'dart:io';

import 'package:chatflare/core/models/chatflare_user.dart';
import 'package:chatflare/core/services/auth/auth_firebase_service.dart';
import 'package:chatflare/core/services/auth/auth_mock_service.dart';

abstract class AuthService {
  ChatflareUser? get currentUser;

  Stream<ChatflareUser?> get userChanges;

  Future<void> signup(String nome, String email, String password, File? image);
  Future<void> login(String email, String password);
  Future<void> logout();

  factory AuthService() {
    // return AuthMockService();
    return AuthFirebaseService();
  }
}
