import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/screens/welcome_screen.dart';
import 'profileMenuWidget.dart';
import 'profile_update.dart';

class profile_screen extends StatelessWidget {
  static String id = "ProfileScreen";
  const profile_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.nights_stay_outlined),
            color: Colors.black,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
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
                    child: const Image(
                        image: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfWwvGQn3hznks_Xjm7qv27_cZ_rOcEOfsVQ&usqp=CAU")),
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
                      color: Color.fromARGB(255, 255, 251, 12),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "User-Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              "UserProfile@gmail.com",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                    side: BorderSide.none, shape: const StadiumBorder()),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const profile_update()),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            profileMenuWidget(
              title: "Settings",
              icon: (Icons.settings_sharp),
              onPress: () {},
              endIcon: true,
            ),
            profileMenuWidget(
              title: "Biling",
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
              title: "Settings",
              icon: (Icons.settings),
              onPress: () {},
              endIcon: false,
            ),
            profileMenuWidget(
              title: "Log-Out",
              icon: (Icons.logout),
              textColor: Color.fromARGB(255, 173, 39, 29),
              onPress: () {},
              endIcon: true,
            ),
          ],
        ),
      ),
    );
  }
}
