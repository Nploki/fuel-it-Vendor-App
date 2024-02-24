import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Auth_Provider extends ChangeNotifier {
  String error = '';
  String msg = '';
  String email = '';
  late double shopLatitude;
  late double shopLongitude;

  String? getimage(String category) {
    String imageUrl;
    switch (category) {
      case 'Bharath':
        imageUrl =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRO1GpYyL6r7BZy5pejFe7F0tsrgQ3-8GQWdQ&usqp=CAU';
        break;
      case 'Hp':
        imageUrl =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZnFugfBQhI6wtLCIxzVCyYA4KlSPnmd7hUQ&usqp=CAU';
        break;
      case 'Indian Oil':
        imageUrl =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQImaDlH1L6RNiFwpzBS9QxOuFq4yznvnrPYw&usqp=CAU';
        break;
      case 'Naayara':
        imageUrl =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJDKiUkFQKc4fWLP4TfGQheIyxtp91nl-BY_gN-rcv9hcYge4LzrU5BZj9GLjy_NMt_Tc&usqp=CAU';
        break;
      case 'Shell':
        imageUrl =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAuCF6WdP5VkCHz8Z2r0HgHl526fdLTwM1sA&usqp=CAU';
        break;
      default:
        imageUrl =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROuZ6TJztuG2zH8J2YBudvWTjxMPHoqQk--g&usqp=CAU';
        break;
    }

    return imageUrl;
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

  // SELLER LOGIN
  Future<UserCredential?> loginSeller(
      BuildContext context, String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    notifyListeners();

    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
      return null;
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<String?> reset_Password(String email) async {
    this.email = email;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
      return e.message.toString();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      return e.toString();
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
      'address': address,
      'location': GeoPoint(latitude, longitude),
      'shopOpen': true,
      'rating': 0.00,
      'totalrating': 0,
      'isTopPicked': false,
      'accVerified': false,
      'water': true,
      'air': true,
      'toilet': true
    });
    return null;
  }
}
