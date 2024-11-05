import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: TextButton(onPressed: (){
        GoRouter.of(context).push('/profile_fitInfo');
      }
   , child: const Text('profile_fitInfo')),
    );
  }
}
