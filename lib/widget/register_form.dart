import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fuel_it_vendor_app/provider/authprovider.dart';
import 'package:fuel_it_vendor_app/screens/LoginScreen.dart';
import 'package:fuel_it_vendor_app/screens/home_screen.dart';
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

  String bunkAddres = '';
  String email = '';
  String password = '';
  String mobileno = '';
  String shopName = '';
  String? _selectedValue;
  String _url = "";

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
        ? Center(
            child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
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
                              Container(
                                height: 70,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedValue = newValue;
                                    });
                                  },
                                  items: [
                                    'Bharath',
                                    'Hp',
                                    'Indian Oil',
                                    'Naayara',
                                    'Shell',
                                  ].map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    );
                                  }).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Bump Category',
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
                                  obscureText: _isPasswordVisible,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    labelText: "Password",
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
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
                                  obscureText: !_isConfirmPasswordVisible,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    labelText: "Re-Enter Password",
                                    hintText: "Re-Enter Password",
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible
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
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      // Inside your onPressed callback in the "Register" Button
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          _auth_data
                              .registerSeller(email, password)
                              .then((credential) async {
                            if (credential.user?.uid != null) {
                              // register vendor
                              String? imageUrl =
                                  await _auth_data.getimage(_selectedValue!);

                              if (imageUrl != null) {
                                _auth_data
                                    .saveSellerDataToDb(
                                  url: imageUrl,
                                  shopName: shopName,
                                  mobileno: mobileno,
                                  latitude: lat,
                                  longitude: longt,
                                  address: bunkAddres,
                                )
                                    .then((value) {
                                  setState(() {
                                    _formKey.currentState?.reset();
                                    _isLoading = false;
                                  });
                                  // AFTER SUCCESSFUL SAVE DATA
                                  Navigator.pushReplacementNamed(
                                      context, home_Screen.id);
                                });
                              }
                            }
                          });
                        } else {
                          Scaffoldmessage('Fill all details Correctly');
                        }
                      },

                      child: Text("Register"),
                    ),
                  ),
                  const SizedBox(height: 7.5),

                  const Text("- OR -"),
                  const SizedBox(height: 7.5),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
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
