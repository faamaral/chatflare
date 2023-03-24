import 'dart:io';

import 'package:chatflare/core/models/auth_form_data.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthFormData _authFormData = new AuthFormData();

  void handleImagePick(File image) {
    _authFormData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  void _submit() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_authFormData.image == null && _authFormData.isSignup) {
      return _showError('Imagem não selecionada!');
    }
    widget.onSubmit(_authFormData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authFormData.isSignup)
                UserImagePicker(
                  onImagePick: handleImagePick,
                ),
              if (_authFormData.isSignup)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _authFormData.name,
                  onChanged: (name) => _authFormData.name = name,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    final name = value ?? '';
                    if (name.trim().length < 5) {
                      return 'Nome deve ter no minimo 5 caracteres.';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: ValueKey('email'),
                initialValue: _authFormData.email,
                onChanged: (email) => _authFormData.email = email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  final email = value ?? '';
                  if (email.trim().isEmpty) {
                    return 'Email não pode ficar em branco';
                  }
                  if (!EmailValidator.validate(email)) {
                    return 'Endereço de email invalido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: ValueKey('password'),
                initialValue: _authFormData.password,
                onChanged: (password) => _authFormData.password = password,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
                validator: (value) {
                  final password = value ?? '';
                  if (password.trim().length < 8) {
                    return 'A senha deve ter no minimo 8 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  _authFormData.isLogin ? 'Entrar' : 'Cadastrar',
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(
                    () {
                      _authFormData.toggleAuthMode();
                    },
                  );
                },
                child: Text(
                  _authFormData.isLogin
                      ? 'Criar uma nova conta?'
                      : 'Já possui conta?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
