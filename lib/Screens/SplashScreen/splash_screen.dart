import 'package:flutter/material.dart';
import 'package:inventory_system/Routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // loading screen
    Future.delayed(Duration(seconds: 3), () {
      context.mounted
          ?
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, loginScreen)
          // ignore: avoid_print
          : print("context dismounted befor the end of future");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red[300],
      ),
    );
  }
}
