import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            onChanged: presenter.setEmail,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            onChanged: presenter.setPassword,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: presenter.loginWithKakao,
            child: const Text('LoginWithKaKao'),
          ),
          ElevatedButton(
            onPressed: presenter.loginWithNaver,
            child: const Text('LoginWithNaver'),
          ),
          ElevatedButton(
            onPressed: presenter.loginWithApple,
            child: const Text('LoginWithApple'),
          ),
          ElevatedButton(
            onPressed: AuthService().logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
