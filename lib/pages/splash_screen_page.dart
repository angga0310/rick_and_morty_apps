import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rick_and_morty_apps/widgets/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Durasi Splash 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 56, 199, 227),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/rick.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            Text(
              "Rick and Morty",
              style: TextStyle(
                fontFamily: "Rick",
                fontSize: 36,
                color: Colors.white,
                shadows: [
                  Shadow(
                      offset: Offset(0, 4),
                      blurRadius: 8,
                      color: Color(0xFF60C43E).withOpacity(1.00))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
