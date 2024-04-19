import 'package:flutter/material.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:sekulkit/view/auth/login.dart';
import 'package:sekulkit/view/main/home.dart';
import 'package:sekulkit/view/main/main_screen.dart';

// import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(microseconds: 1500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  client.auth.currentSession != null
                      ? const MainScreen()
                      : const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png'),
        ),
      ),
    );
  }
}
