import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';

class Auth_Provider extends ChangeNotifier {
  late File image;
  bool isPicAvail = false;
  String pickerError = '';
  String error = '';
  String email = '';
  late double shopLatitude;
  late double shopLongitude;

  Future<File> getImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  Future<Position> getCurrentAddress() async {
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

  Future<UserCredential> registerSeller(String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    notifyListeners();
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

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

//save vendor details to firestore

  Future<void> saveSellerDataToDb(
      {required String url,
      required String shopName,
      required String mobileno,
      required double latitude,
      required double longitude,
      required String address}) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _seller =
        FirebaseFirestore.instance.collection('seller').doc(user?.uid);
    _seller.set({
      'uid': user?.uid,
      'shopName': shopName,
      'mobileno': mobileno,
      'url': url,
      'email': this.email,
      // 'latitude': latitude,
      // 'longitude': longitude,
      'address': address,
      'location': GeoPoint(latitude, longitude),
      'shopOpen': true,
      'rating': 0.00,
      'totalrating': 0,
      'isTopPicked': true,
    });
    return null;
  }
}
