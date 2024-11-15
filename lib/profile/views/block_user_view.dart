import 'package:flutter/material.dart';

class ProfileBlockUserView extends StatefulWidget {
  const ProfileBlockUserView({super.key});

  @override
  State<ProfileBlockUserView> createState() => _ProfileBlockUserViewState();
}

class _ProfileBlockUserViewState extends State<ProfileBlockUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버디 계정'),
      ),
    );
  }
}
