import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/provider/authprovider.dart';
import 'package:fuel_it_vendor_app/widget/register_form.dart';

class sign_up extends StatefulWidget {
  static String id = "sign_up";
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  @override
  Widget build(BuildContext context) {
    final Auth_Provider _auth_data = Auth_Provider();
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
          child: Column(
            children: [
              // profilePic(),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 50, top: 50, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                    width: 150,
                    height: 150,
                    child: Image.network(
                        "https://static.vecteezy.com/system/resources/previews/008/801/959/original/fire-icon-flame-logo-fire-design-illustration-fire-icon-simple-sign-vector.jpg"),
                  ),
                ),
              ),
              Container(
                  height: 550,
                  width: MediaQuery.of(context).size.width * 0.985,
                  child: RegisterForm()),
            ],
          ),
        ),
      ),
    );
  }
}
