import 'package:flutter/material.dart';
import 'package:jarvis/screens/splash_screen.dart';

import '../screens/add_new_api_screen.dart';
import './service/secrets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xff191825),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff191825),
        ),
      ),
      title: 'jarvis',
      // home: const AddNewApiScreen(),
      home: const SplashScreen(),
    );
  }
}
