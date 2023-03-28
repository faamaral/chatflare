import 'package:chatflare/core/models/auth_form_data.dart';
import 'package:chatflare/core/services/auth/auth_mock_service.dart';
import 'package:flutter/material.dart';

import '../components/auth_form.dart';
import '../core/services/auth/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoanding = false;
  Future<void> _handleSubmit(AuthFormData formData) async {
    try {
      if (!mounted) return;
      setState(() => isLoanding = true);
      if (formData.isLogin) {
        await AuthService().login(formData.email, formData.password);
      } else {
        await AuthService().signup(
            formData.name, formData.email, formData.password, formData.image);
      }
    } on Exception catch (e) {
      // TODO
    } finally {
      if (!mounted) return;
      setState(() => isLoanding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(
                onSubmit: _handleSubmit,
              ),
            ),
          ),
          if (isLoanding)
            Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
