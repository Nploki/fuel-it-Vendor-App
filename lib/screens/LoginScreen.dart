import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/provider/authprovider.dart';
import 'package:fuel_it_vendor_app/widget/forgot_Password.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuel_it_vendor_app/screens/SignUpScreen.dart';
import 'package:fuel_it_vendor_app/screens/home_screen.dart';
import 'package:fuel_it_vendor_app/screens/signup.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth_Provider _auth_data = Auth_Provider();

  bool _isVisible = false;
  bool _isLoading = false;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  String email = '';
  String password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Image(
                image: const NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo9dqwwDcgvlxyYsZBLNKJf3zih52MW0VcVQ&usqp=CAU"),
                height: size.height * 0.2,
              ),
              const Text(
                "Welcome Back,",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const Text(
                "Let's Get In With Your Account's Credentia.",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            prefixIcon: Icon(Icons.email_outlined),
                            labelText: "E-Mail",
                            hintText: "E-Mail",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordTextController,
                        obscureText: _isVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your Password';
                          }
                          if (value.length < 6) {
                            return 'Password is greater than 5 characters';
                          }
                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint),
                            labelText: "Password",
                            hintText: "Password",
                            suffixIcon: IconButton(
                              icon: _isVisible
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined),
                              onPressed: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Forgot_Password_screen.id);
                          },
                          child: Text(
                            "Forgot Password ? ",
                            style: GoogleFonts.play(
                                color: Colors.blue, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                height: 45,
                child: _isLoading
                    ? const CupertinoActivityIndicator(
                        radius: 15,
                        color: Color.fromARGB(255, 255, 234, 0),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _auth_data
                                .loginSeller(context, email, password)
                                .then((credential) {
                              if (credential != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.pushReplacementNamed(
                                    context, home_Screen.id);
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(_auth_data.error),
                                ));
                              }
                            });
                          }
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("- OR -"),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: size.width,
                      height: 35,
                      child: OutlinedButton.icon(
                        icon: const Image(
                          image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtdUuKocOzOeu92a6nxPTGEPci8ZuQsfz3Mg&usqp=CAU"),
                          width: 30.0,
                        ),
                        label: Text("Sign In With Google"),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sign_up()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an Account?",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: " Sign Up",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
