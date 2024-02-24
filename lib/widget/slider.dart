import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/provider/auth_provier.dart';
import 'package:fuel_it_vendor_app/screens/dashboard_screen.dart';
import 'package:fuel_it_vendor_app/screens/product_screen.dart';
import 'package:fuel_it_vendor_app/screens/profile/profile_screen.dart';

class slider extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const slider({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<slider> createState() => _sliderState();
}

class _sliderState extends State<slider> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? vendorData;

  @override
  void initState() {
    super.initState();
    getVendorData();
  }

  Future<void> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection('seller')
        .doc(user?.uid)
        .get();
    setState(() {
      vendorData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Product_provider _provider = Product_provider();
    _provider.shopName = vendorData?.get("shopName") ?? "";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 225,
            child: DrawerHeader(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: vendorData != null
                              ? Image.network(
                                  vendorData!.get("url") ?? "",
                                  height: 120,
                                  width: 120,
                                )
                              : null),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(
                          vendorData != null ? vendorData!.get("shopName") : "",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.dashboard_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: const Text(
                    'DashBoard',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, dashboard_screen.id);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: const Text('Products'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, product_screen.id);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.wallet_giftcard_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: const Text('Coupons'),
                  onTap: () {
                    Navigator.pop(context);
                    //  Navigator.pushReplacementNamed(
                    //     context, .id);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.list_alt_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: const Text('Orders'),
                  onTap: () {
                    Navigator.pop(context); // C.lose the drawer
                    // Handle orders tap
                  },
                ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.settings,
                    // color: Colors.red,
                    size: 30,
                  ),
                  title: const Text('Profile & Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, profile_screen.id);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.power_settings_new_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: const Text('Log - Out'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
