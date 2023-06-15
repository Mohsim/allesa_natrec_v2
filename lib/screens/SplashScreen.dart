import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Core/Animation/Fade_Animation.dart';
import 'Authentication/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeAnimation(
          delay: 1,
          child: Image.asset(
            'assets/alessa.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
