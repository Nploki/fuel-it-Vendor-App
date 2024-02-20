import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/screens/SignUpScreen.dart';
import 'package:fuel_it_vendor_app/screens/signup.dart';

class LoginScreen extends StatelessWidget {
  static String id = "LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 25,
            ),
            Image(
              image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo9dqwwDcgvlxyYsZBLNKJf3zih52MW0VcVQ&usqp=CAU"),
              height: size.height * 0.2,
            ),
            Text(
              "Welcome Back,",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            Text(
              "Let's Get In With Your Account's Credentia.",
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            Form(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "E-Mail",
                        hintText: "E-Mail",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fingerprint),
                        labelText: "Password",
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye_outlined),
                          onPressed: null,
                        ),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Forgot Password"),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const profile_screen(),
                        //   ),
                        // );
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("- OR -"),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
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
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => sign_up()),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an Account?",
                            style: TextStyle(color: Colors.black),
                            children: const [
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
            ))
          ]),
        ),
      ),
    );
  }
}
