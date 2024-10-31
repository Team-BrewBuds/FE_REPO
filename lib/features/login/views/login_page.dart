import 'package:brew_buds/core/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../presenter/login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextField(
            onChanged: presenter.setEmail,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            onChanged: presenter.setPassword,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: presenter.loginWithKakao,
            child: Text('LoginWithKaKao'),
          ),
          ElevatedButton(
            onPressed: presenter.loginWithNaver,
            child: Text('LoginWithNaver'),
          ),
          ElevatedButton(
            onPressed: presenter.loginWithApple,
            child: Text('LoginWithApple'),
          ),
          ElevatedButton(
            onPressed: AuthService().logout,
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}