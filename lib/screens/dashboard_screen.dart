import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';
import 'package:fuel_it_vendor_app/widget/app_bar.dart';
import 'package:fuel_it_vendor_app/widget/slider.dart';

class dashboard_screen extends StatefulWidget {
  static const String id = "dashboard_screen";

  const dashboard_screen({Key? key}) : super(key: key);

  @override
  dashboard_screenState createState() => dashboard_screenState();
}

class dashboard_screenState extends State<dashboard_screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: app_Bar(context, "Dashboard"),
      drawer: slider(
        scaffoldKey: _scaffoldKey,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
          child: const Text('Log Out'),
        ),
      ),
    );
  }
}
