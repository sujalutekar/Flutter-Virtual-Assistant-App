import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/profile_screen.dart';
import '../service/secrets.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: SafeArea(
        child: Column(
          children: [
            // AppBar(
            //   title: Text(
            //     bossName.isEmpty ? 'Hello there' : 'Hello $bossName',
            //     style: const TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            //   automaticallyImplyLeading: false,
            // ),\
            const Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.black87,
            ),
            Text(
              bossName,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              // style: const TextStyle(
              //   fontSize: 20,
              // ),
            ),
            const SizedBox(
              height: 20,
            ),
            // const Divider(
            //   color: Colors.black,
            // ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
                print('Pressed on listtile');
              },
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text(
                  'Profile',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            // const Divider(
            //   color: Colors.black,
            // ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
