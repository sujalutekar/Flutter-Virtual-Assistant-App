import 'package:flutter/material.dart';
import 'package:jarvis/screens/profile_screen.dart';
import 'package:jarvis/service/secrets.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff191825),
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: Text(
                bossName.isEmpty ? 'Hello there' : 'Hello $bossName',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
                print('Pressed on listtile');
              },
              child: const ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
