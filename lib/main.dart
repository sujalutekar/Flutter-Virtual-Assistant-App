import 'package:flutter/material.dart';

import './screens/home_page.dart';
import './screens/splash_screen.dart';
import './screens/profile_screen.dart';
import './screens/add_new_api_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.grey.shade300,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade300,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      title: 'jarvis',
      // home: const AddNewApiScreen(),
      home: const HomePage(),
      routes: {
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        SplashScreen.routeName: (ctx) => const SplashScreen(),
      },
    );
  }
}
