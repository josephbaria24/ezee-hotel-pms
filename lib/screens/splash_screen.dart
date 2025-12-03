import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ezee/screens/intro_page.dart';
import 'dart:async';
import 'login_signup_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay before navigating to AuthPage
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LottieWidget(),
      ),
    );
  }
}

class LottieWidget extends StatelessWidget {
  const LottieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'lib/assets/icons/splash2.json',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}
