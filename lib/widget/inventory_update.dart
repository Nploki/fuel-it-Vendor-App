import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool trackInventory = false;
  String selectedProductId = '';
  int quantity = 0;
  int lowQuantity = 0;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateProductQuantity(String uid) async {
    await FirebaseFirestore.instance.collection('products').doc(uid).update({
      'stockQty': quantity,
      'lowStackQty': lowQuantity,
    });
    // Clear the selectedProductId to reset the form
    setState(() {
      selectedProductId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Track Inventory'),
              value: trackInventory,
              onChanged: (value) {
                setState(() {
                  trackInventory = value;
                });
              },
            ),
            if (trackInventory)
              Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: snapshot.data!.docs.map((doc) {
                          var data = doc.data() as Map<String,
                              dynamic>?; // Explicit cast to Map<String, dynamic> or null
                          if (data != null && data['sellerUid'] == user!.uid) {
                            String productName = data['productName'];
                            String productId = data['prdId'];
                            return ListTile(
                              title: Text(
                                productName,
                                style: TextStyle(
                                  color: selectedProductId == productId
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              leading: Icon(
                                Icons.double_arrow_sharp,
                                color: selectedProductId == productId
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedProductId = "";
                                  selectedProductId = productId;
                                  quantity = data['stockQty'];
                                  lowQuantity = data['lowStackQty'];
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      int tempQuantity = quantity;
                                      int tempLowQuantity = lowQuantity;

                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return AlertDialog(
                                            title:
                                                const Text('Update Inventory'),
                                            content: Container(
                                              width: double.maxFinite,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Quantity'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.remove,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (tempQuantity >
                                                                0) {
                                                              tempQuantity--;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      Text(tempQuantity
                                                          .toString()),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: Colors.green,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            tempQuantity++;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text('Low Quantity'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.remove,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (tempLowQuantity >
                                                                0) {
                                                              tempLowQuantity--;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      Text(tempLowQuantity
                                                          .toString()),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: Colors.green,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            tempLowQuantity++;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    // selectedProductId = "";
                                                    quantity = tempQuantity;
                                                    lowQuantity =
                                                        tempLowQuantity;
                                                  });
                                                  updateProductQuantity(
                                                      selectedProductId);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Update'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                });
                              },
                            );
                          } else {
                            // Return an empty container if the document doesn't match the criteria
                            return Container();
                          }
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
