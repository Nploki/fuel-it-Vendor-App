import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product_provider with ChangeNotifier {
  String shopName = "";
  String prdName = "";
  String prdImage = "";
  Future<Map<String, dynamic>> uploadFile(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      await storage
          .ref("productImage/{$this.shopName}$this.prdName")
          .putFile(file);
      String downloadURL = await storage
          .ref("productImage/{$this.shopName}$this.prdName")
          .getDownloadURL();
      bool isPicAvail = true;
      return {"isPicAvail": isPicAvail, "downloadURL": downloadURL};
    } on FirebaseException catch (e) {
      print(e.code);
      rethrow;
    }
  }

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                  child: TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ))
            ],
          );
        });
  }

  Future<void> saveProductDataToDb(
      {productName,
      description,
      price,
      comparedPrice,
      collection,
      brand,
      sku,
      maincategory,
      subcategory,
      quantity,
      prdImageUrl,
      tax,
      stockQty,
      lowStackQty,
      context}) async {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(prdName).set({
        'shopName': shopName,
        'sellerUid': user?.uid,
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'sku': sku,
        'category': {
          'mainCategory': maincategory,
          'subCategory': subcategory,
          'categoryImage': prdImageUrl
        },
        'quantity': quantity,
        'tax': tax,
        'stockQty': stockQty,
        'lowStackQty': lowStackQty,
        'published': false,
        'prdId': prdName
      });
      alertDialog(
          context: context,
          title: "SAVE DATA",
          content: "Prdouct Detail Saved Successfully");
    } catch (e) {
      alertDialog(
          context: context,
          title: "SAVE DATA",
          content: "Error Occurred While Saving Product Details!");
    }
  }
}
