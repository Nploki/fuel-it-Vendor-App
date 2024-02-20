import 'dart:io';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fuel_it_vendor_app/provider/authprovider.dart';
import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel_it_vendor_app/screens/profile/profile_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isConfirmPasswordVisible = true;
  bool _isPasswordVisible = true;
  bool _isLoading = false;

  late double lat;
  late double longt;

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    bunkAddres =
        '${place.locality} ,\n${place.administrativeArea} - ${place.postalCode} , ${place.country}.';
  }

  Future<String> uploadFile(filepath) async {
    File file = File(filepath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      // Upload file
      await _storage
          .ref("upload/bunkProfile/${_nameTextController.text}")
          .putFile(file);

      // Get download URL after successful upload
      String downloadURL = await _storage
          .ref("upload/bunkProfile/${_nameTextController.text}")
          .getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      print("Firebase Storage Upload Error: ${e.code}");
      // Handle the error, you might want to return a default or error URL
      return "Error occurred during upload";
    }
  }

  String bunkAddres = '';
  String email = '';
  String password = '';
  String mobileno = '';
  String shopName = '';

  // TextEditingController for each form field
  var _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Auth_Provider _auth_data = Auth_Provider();
    Scaffoldmessage(message) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Scaffold(
            body: Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Business Name TextFormField
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Shop Name";
                                    }
                                    setState(() {
                                      _nameTextController.text = value;
                                    });
                                    setState(() {
                                      shopName = value;
                                    });
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_outlined),
                                    labelText: "Business Name",
                                    hintText: "Business Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7.5),

                              // Email TextFormField
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: _emailTextController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Email-Id";
                                    }
                                    final bool _isValid =
                                        EmailValidator.validate(
                                            _emailTextController.text);
                                    if (!_isValid) {
                                      return "Enter a Valid Email-Id";
                                    }
                                    setState(() {
                                      email = value;
                                    });
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    labelText: "E-Mail",
                                    hintText: "E-Mail",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7.5),

                              // Phone Number TextFormField
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: _phoneTextController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Phone Number";
                                    }
                                    if (value.length != 10) {
                                      return "Enter a Valid Phone Number";
                                    }
                                    setState(() {
                                      mobileno = value;
                                    });
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    prefixText: "+91  ",
                                    prefixIcon: Icon(Icons.phone),
                                    labelText: "Phone No",
                                    hintText: "Phone No",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7.5),

                              // Password TextFormField
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: _passwordTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Your Password";
                                    }
                                    if (value.length != 6) {
                                      return "Password Must be Greater than 6 Characters";
                                    }
                                    return null;
                                  },
                                  obscureText: _isConfirmPasswordVisible,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    labelText: "Password",
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7.5),

                              // Confirm Password TextFormField
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: _confirmPasswordTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Your Password";
                                    }
                                    if (value.length < 6) {
                                      return "Password needs 6 characters";
                                    }
                                    if (_passwordTextController.text != value) {
                                      return "Password Doesn't Match";
                                    }
                                    setState(() {
                                      password = value;
                                    });
                                    return null;
                                  },
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    labelText: "Re-Enter Password",
                                    hintText: "Re-Enter Password",
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmPasswordVisible =
                                              !_isConfirmPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7.5),

                              // Bunk Address TextFormField
                              SizedBox(
                                height: 100,
                                child: TextFormField(
                                  maxLines: 4,
                                  controller: _addressTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Bunk Address";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.add_business_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        Position position = await _auth_data
                                            .getCurrentAddress();
                                        GetAddressFromLatLong(position);
                                        setState(() {
                                          _addressTextController.text =
                                              bunkAddres;
                                          lat = position.latitude;
                                          longt = position.longitude;
                                        });
                                      },
                                      icon:
                                          const Icon(Icons.location_searching),
                                    ),
                                    labelText: "Bunk Address",
                                    hintText: "Bunk Address",
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // "Register" Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: ElevatedButton(
                      // Inside your onPressed callback in the "Register" Button
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Call getImage to set a valid image before using it in uploadFile
                          _auth_data.getImage().then((file) {
                            _auth_data
                                .registerSeller(email, password)
                                .then((credential) {
                              if (credential.user?.uid != null) {
                                uploadFile(file.path).then(
                                  (url) {
                                    //register vendor
                                    _auth_data
                                        .saveSellerDataToDb(
                                            url: url,
                                            shopName: shopName,
                                            mobileno: mobileno,
                                            latitude: lat,
                                            longitude: longt,
                                            address: bunkAddres)
                                        .then((value) {
                                      setState(() {
                                        _formKey.currentState?.reset();
                                        _isLoading = false;
                                      });
                                      //AFTER SUCCESSFUL SAVE DATA
                                      Navigator.pushReplacementNamed(
                                          context, profile_screen.id);
                                    });
                                  },
                                );
                              } else {
                                //register failed
                                setState(() {
                                  _isLoading = false;
                                });
                                Scaffoldmessage(_auth_data.error);
                              }
                            });
                          });
                        } else {
                          Scaffoldmessage('Add Profile Pic');
                        }
                      },

                      child: Text("Register"),
                    ),
                  ),
                  const SizedBox(height: 7.5),

                  // "OR" Text
                  const Text("- OR -"),
                  const SizedBox(height: 7.5),

                  // Already have an Account? LOGIN Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Already have an Account?",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: " LOGIN",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
