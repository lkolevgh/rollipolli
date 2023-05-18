import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:polls/screens/navigation/navigation_page.dart';
import 'screens/login/login_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const NavigationPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
