import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserManagementDialog extends StatefulWidget {
  @override
  State<UserManagementDialog> createState() => _UserManagementDialogState();
}

class _UserManagementDialogState extends State<UserManagementDialog> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('seller')
          .doc(user!.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          bool _gas = data['gas'];
          bool _water = data['drinking_water'];
          bool _toilet = data['restroom'];

          return AlertDialog(
            backgroundColor: Colors.amber.shade200,
            title: const Text("Bump Facilities !"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  value: _gas,
                  onChanged: (selected) {
                    setState(() {
                      _gas = selected;
                    });
                    FirebaseFirestore.instance
                        .collection('seller')
                        .doc(user!.uid)
                        .update({'gas': selected});
                  },
                  title: const Text("Gas"),
                  activeColor: Colors.green,
                ),
                SwitchListTile(
                  value: _water,
                  onChanged: (selected) {
                    setState(() {
                      _water = selected;
                    });
                    FirebaseFirestore.instance
                        .collection('seller')
                        .doc(user!.uid)
                        .update({'drinking_water': selected});
                  },
                  title: const Text("Water"),
                  activeColor: Colors.green,
                ),
                SwitchListTile(
                  value: _toilet,
                  onChanged: (selected) {
                    setState(() {
                      _toilet = selected;
                    });
                    FirebaseFirestore.instance
                        .collection('seller')
                        .doc(user!.uid)
                        .update({'restroom': selected});
                  },
                  title: const Text("Toilet"),
                  activeColor: Colors.green,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.chakraPetch(
                      color: Colors.amber.shade900,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
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
