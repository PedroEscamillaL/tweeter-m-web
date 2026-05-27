import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const MotoSocialApp());
}

class MotoSocialApp extends StatelessWidget {
  const MotoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Tweeter',

      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      home: const LoginScreen(),
    );
  }
}