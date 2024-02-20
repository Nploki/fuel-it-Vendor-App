import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/provider/authprovider.dart';
import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgot_Password_screen extends StatefulWidget {
  static String id = "forgot_password";
  const Forgot_Password_screen({Key? key}) : super(key: key);

  @override
  State<Forgot_Password_screen> createState() =>
      _ForgotPasswordMailScreenState();
}

class _ForgotPasswordMailScreenState extends State<Forgot_Password_screen> {
  final Auth_Provider _auth_data = Auth_Provider();

  String email = '';

  bool _isLoading = false;
  final _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Scaffoldmessage(message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Image(
                  image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTMo1Sp_iSOpZ-GYs9-4BClpmmdoWcHtNO4umftd2T_pxYYKR6mPhBuQOoTU_ZO3VeCXk&usqp=CAU"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Forgot Password",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.chakraPetch(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Enter Your Email-Id \n To Get Reset Password Code ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailTextController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your Email Id';
                          }
                          final bool _isValid = EmailValidator.validate(
                              _emailTextController.text);
                          if (!_isValid) {
                            return "Enter a Valid Email-Id";
                          }
                          setState(() {
                            email = value;
                          });
                          return null;
                        },
                        decoration: const InputDecoration(
                            label: Text("E-Mail"),
                            hintText: "E-Mail",
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: _isLoading
                            ? const CupertinoActivityIndicator(
                                radius: 15,
                                color: Colors.amberAccent,
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() !=
                                      null) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _auth_data.reset_Password(email).then(
                                      (value) {
                                        if (value != null) {
                                          Scaffoldmessage(value);
                                        } else {
                                          Scaffoldmessage(
                                              "Password Reset Link Sent SuccessFully");
                                          Navigator.pushReplacementNamed(
                                              context, LoginScreen.id);
                                        }
                                        ;
                                      },
                                    );
                                  }
                                },
                                child: Text(
                                  "Get - OTP",
                                  style: GoogleFonts.yatraOne(
                                      fontSize: 22.5,
                                      color: Color.fromARGB(255, 2, 108, 76),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
