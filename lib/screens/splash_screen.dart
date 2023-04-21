import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import './home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentIndex = 0;
  String jarvisText = 'J.A.R.V.I.S.';
  final flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    typeWritingEffect();
    systemSpeak();
  }

  Future<void> systemSpeak() async {
    await flutterTts.speak('Welcome Back Sir, We\'re Online & Ready.');
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  Future<void> typeWritingEffect() async {
    if (currentIndex < jarvisText.length) {
      currentIndex++;
    } else {
      navigateToHomePage();
      return;
    }

    setState(() {});

    Future.delayed(const Duration(milliseconds: 250), () {
      typeWritingEffect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/jarvis.png'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              jarvisText.substring(0, currentIndex),
              style: GoogleFonts.nunito(fontSize: 30, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
