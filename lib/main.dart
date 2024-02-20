import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/firebase_options.dart';
import 'package:fuel_it_vendor_app/provider/authprovider.dart';
import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';
import 'package:fuel_it_vendor_app/screens/SignUpScreen.dart';
import 'package:fuel_it_vendor_app/screens/home_screen.dart';
import 'package:fuel_it_vendor_app/screens/profile/profile_screen.dart';
import 'package:fuel_it_vendor_app/screens/welcome_screen.dart';
import 'package:fuel_it_vendor_app/widget/forgot_Password.dart';
import 'package:provider/provider.dart';
import 'package:fuel_it_vendor_app/provider/auth_provier.dart';
import 'package:fuel_it_vendor_app/provider/location_provider.dart';
import 'package:fuel_it_vendor_app/screens/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => Auth_Provider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          profile_screen.id: (context) => profile_screen(),
          Forgot_Password_screen.id: (context) => Forgot_Password_screen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          sign_up.id: (context) => sign_up(),
          home_Screen.id: (context) => home_Screen(),
        });
  }
}
