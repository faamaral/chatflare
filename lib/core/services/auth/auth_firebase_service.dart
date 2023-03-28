import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chatflare/core/services/auth/auth_service.dart';
import 'package:chatflare/utils/constants/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> signup(
      String name, String email, String password, File? image) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential == null) return;

    // 1. upload da imagem do usuario
    final imageName = '${credential.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);
    // 2. atualizar atributos do usuario
    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageUrl);

    // salvar usuario no bd (opcional)
    await _saveChatflareUser(_toChatflareUser(credential.user!, imageUrl));
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

  static ChatflareUser _toChatflareUser(User user, [String? imageUrl]) {
    return ChatflareUser(
        id: user.uid,
        name: user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        imageUrl: imageUrl ?? user.photoURL ?? AppImages.avatar);
  }
}
