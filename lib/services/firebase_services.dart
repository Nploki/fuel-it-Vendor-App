import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase_services {
  CollectionReference category =
      FirebaseFirestore.instance.collection("vendor_category_image");
}
