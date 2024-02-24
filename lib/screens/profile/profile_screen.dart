import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/screens/home_screen.dart';
import 'package:fuel_it_vendor_app/widget/UserManagementDialog%20.dart';
import 'package:fuel_it_vendor_app/widget/slider.dart';
import 'profileMenuWidget.dart';
import 'profile_update.dart';

class profile_screen extends StatefulWidget {
  static String id = "ProfileScreen";

  profile_screen({Key? key}) : super(key: key);

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String head = "Profile";

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('seller')
          .doc(user.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String shopName = data['shopName'] ?? "Not Found";
          String email = data['email'] ?? "Not Found";
          String imageUrl = data['url'] ??
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW4n7CbPgSjtTv4HOmt1qEmPfpXZoYOCM0OA&usqp=CAU";
          bool verified = data['accVerified'] ?? false;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, home_Screen.id);
                },
              ),
              title: Text(head),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.nights_stay_outlined),
                  color: Colors.black,
                )
              ],
            ),
            drawer: slider(
              scaffoldKey: _scaffoldKey,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(imageUrl),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: verified ? Colors.green : Colors.red),
                          child: verified
                              ? const Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  color: Colors.white,
                                  size: 25,
                                )
                              : const Icon(
                                  CupertinoIcons.xmark_seal_fill,
                                  color: Colors.white,
                                  size: 25,
                                ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    shopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const profile_update()),
                        );
                      },
                      child: const Text("Edit Profile"),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 40,
                  ),
                  profileMenuWidget(
                    title: "Settings",
                    icon: (Icons.settings_sharp),
                    onPress: () {},
                    endIcon: true,
                  ),
                  profileMenuWidget(
                    title: "Billing",
                    icon: (Icons.account_balance_wallet_sharp),
                    onPress: () {},
                    endIcon: true,
                  ),
                  profileMenuWidget(
                    title: "User Management",
                    icon: (Icons.person_pin_circle_outlined),
                    onPress: () {},
                    endIcon: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  profileMenuWidget(
                    title: "Bump Facilities",
                    icon: (CupertinoIcons.bolt),
                    onPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UserManagementDialog();
                        },
                      );
                    },
                    endIcon: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  profileMenuWidget(
                    title: "Log-Out",
                    icon: (Icons.logout),
                    textColor: const Color.fromARGB(255, 173, 39, 29),
                    onPress: () {},
                    endIcon: true,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
