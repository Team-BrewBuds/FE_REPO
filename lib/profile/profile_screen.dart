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
    return Scaffold(
      body:
      Center(
        child: Column(children: [
          SizedBox(height: 30,),

          Container(
            child: ElevatedButton(onPressed: (){
              context.push('/profile_fitInfo');
            }, child: Text('fit')),
          ),
          Container(
            child: ElevatedButton(onPressed: (){
              context.push('/profile_accountInfo');
            }, child: Text('account')),
          ),
          Container(
            child: ElevatedButton(onPressed: (){
              context.push('/profile_setting');
            }, child: Text('set')),
          ),
          Container(
            child: ElevatedButton(onPressed: (){
              context.push('/profile_edit');
            }, child: Text('hi')),
          ),
        ]),
      )



    );

  }
}
