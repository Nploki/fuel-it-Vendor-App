import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/widget/image_picker.dart';
import 'package:fuel_it_vendor_app/widget/register_form.dart';

class sign_up extends StatelessWidget {
  const sign_up({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                profilePic(),
                Container(height: 500, child: RegisterForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
