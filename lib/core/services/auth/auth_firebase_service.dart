import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chatflare/core/services/auth/auth_service.dart';
import 'package:chatflare/utils/constants/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/chatflare_user.dart';

class AuthFirebaseService implements AuthService {
  static ChatflareUser? _currentUser;
  // static MultiStreamController<ChatflareUser?>? _controller;
  static final _userStream = Stream<ChatflareUser?>.multi((controller) async {
    // _controller = controller;
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatflareUser(user);
      controller.add(_currentUser);
    }
  });
  ChatflareUser? get currentUser => _currentUser;

  Stream<ChatflareUser?> get userChanges => _userStream;

  @override
  Future<void> signup(
      String name, String email, String password, File? image) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      // 1. Upload da foto do usuário
      final imageName = '${credential.user!.uid}.jpg';
      final imageUrl = await _uploadUserImage(image, imageName);

      // 2. atualizar os atributos do usuário
      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);

      // 2.5 fazer o login do usuário
      await login(email, password);

      // 3. salvar usuário no banco de dados (opcional)
      _currentUser = _toChatflareUser(credential.user!, name, imageUrl);
      await _saveChatflareUser(_currentUser!);
    }

    await signup.delete();
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<void> _saveChatflareUser(ChatflareUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);
    await docRef.set(
        {'name': user.name, 'email': user.email, 'imageUrl': user.imageUrl});
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) {
      return null;
    }

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() => null);
    return await imageRef.getDownloadURL();
  }

  static ChatflareUser _toChatflareUser(User user,
      [String? name, String? imageUrl]) {
    return ChatflareUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? AppImages.avatar,
    );
  }
}
