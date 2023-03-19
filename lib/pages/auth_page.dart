import 'package:chatflare/models/auth_form_data.dart';
import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoanding = false;
  void _handleSubmit(AuthFormData formData) {
    setState(() => isLoanding = true);

    setState(() => isLoanding = false);


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
              decoration: BoxDecoration(color: Color.fromRGBO(0,0,0,0.5)),
              child: Center(child: CircularProgressIndicator(),),
            ),
        ],
      ),
    );
  }
}
