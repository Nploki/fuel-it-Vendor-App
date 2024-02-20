import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';
import 'package:fuel_it_vendor_app/screens/welcome_screen.dart';

class home_Screen extends StatelessWidget {
  static const String id = "home_Screen";
  const home_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
            child: Text("Log - Out")),
      ),
    );
  }
}
