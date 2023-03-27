import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chatflare/core/services/auth/auth_service.dart';
import 'package:chatflare/utils/constants/app_images.dart';

import '../../models/chatflare_user.dart';

class AuthMockService implements AuthService {
  static final _defaultUser = ChatflareUser(
    id: '1',
    name: 'Teste',
    email: 'email@example.com',
    imageUrl: AppImages.avatar,
  );
  static Map<String, ChatflareUser> _users = {
    _defaultUser.email: _defaultUser
  };
  static ChatflareUser? _currentUser;
  static MultiStreamController<ChatflareUser?>? _controller;
  static final _userStream = Stream<ChatflareUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });
  ChatflareUser? get currentUser => _currentUser;

  Stream<ChatflareUser?> get userChanges => _userStream;

  Future<void> signup(
      String name, String email, String password, File? image) async {
    final newUser = ChatflareUser(
        id: Random().nextDouble().toString(),
        name: name,
        email: email,
        imageUrl: image?.path ?? AppImages.avatar);

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ChatflareUser? user) {
    _currentUser = user;
    _controller?.add(user);
  }
}
