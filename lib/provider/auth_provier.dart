import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  String error = '';
  bool isPicAvail = false;

  Future<UserCredential> registerSeller(
      String email, String password, File? selectedImage) async {
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user?.uid != null && selectedImage != null) {
        String imageUrl = (await uploadFile(selectedImage,
            'Uploads/showProfilePic/${userCredential.user!.uid}')) as String;
        // Save imageUrl or perform further actions as needed
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'Password is too weak';
        notifyListeners();
        print('Password is too weak');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'This email account already exists.';
        notifyListeners();
        print('This email account already exists.');
      }
      throw e;
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
      throw e;
    }
  }

  Future<Map<String, dynamic>> uploadFile(File file, String storagePath) async {
    try {
      FirebaseStorage _storage = FirebaseStorage.instance;
      await _storage.ref(storagePath).putFile(file);
      String downloadURL = await _storage.ref(storagePath).getDownloadURL();
      bool isPicAvail = true;
      return {"isPicAvail": isPicAvail, "downloadURL": downloadURL};
    } on FirebaseException catch (e) {
      print(e.code);
      throw e; // Rethrow to handle the error in the calling function
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> savaVendorDataOnDb(
      {required String url,
      required String shopName,
      required String shopno,
      required String shopaddess,
      required double latitude,
      required double longitude}) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendor =
        FirebaseFirestore.instance.collection('vendor').doc(user?.uid);

    _vendor.set({
      'uid': user?.uid,
      'ShopName': shopName,
      'ShopNo': shopno,
      'Address': shopaddess,
      'latitude': latitude,
      'longitude': longitude,
      'location': GeoPoint(latitude, longitude),
      'shopOpen': true,
      'rating': 0.00,
      'totalrating': 0,
      'isTopPicked': true,
      'ImageUrl': url,
    });
    return null;
  }
}
