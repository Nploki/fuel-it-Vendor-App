import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';
import 'package:fuel_it_vendor_app/widget/app_bar.dart';
import 'package:fuel_it_vendor_app/widget/slider.dart';

class home_Screen extends StatefulWidget {
  static const String id = "home_Screen";
  const home_Screen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<home_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      key: _scaffoldKey,
      appBar: app_Bar(context, "Home"),
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
    return scaffold;
  }
}
