import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';
import 'package:fuel_it_vendor_app/screens/SignUpScreen.dart';
import 'package:fuel_it_vendor_app/screens/signup.dart';

class WelcomeScreen extends StatelessWidget {
  static String id = "WelcomeScreen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Image(
            image: const NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmUOP-NmcRp5hi4Bur44oVAkQE-oRkAv7iuA&usqp=CAU"),
            height: height * 0.5,
          ),
          const Column(
            children: [
              Text(
                "Welcome To FUEL - IT !",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                "Let's begin with our app \n Through Your Detail's",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black45),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 207, 127, 5),
                      side: const BorderSide(color: Colors.black, width: 1)),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(side: BorderSide(width: 1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sign_up()),
                  );
                },
                child: Text("SIGN UP"),
              ))
            ],
          )
        ]),
      ),
    );
  }
}
