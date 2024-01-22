import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/provider/authprovider.dart';
import 'package:provider/provider.dart';

class profilePic extends StatefulWidget {
  const profilePic({super.key});

  @override
  State<profilePic> createState() => _profilePicState();
}

class _profilePicState extends State<profilePic> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    final _auth_Data = Provider.of<Auth_Provider>(context);

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: InkWell(
        onTap: () {
          _auth_Data.getImage().then((image) {
            setState(() {
              _image = image;
            });
            if (image != null) {
              _auth_Data.isPicAvail = true;
            }
          });
        },
        child: SizedBox(
            width: 150,
            height: 150,
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: _image == null
                    ? Center(child: Text("Add Bunk Image"))
                    : Image.file(
                        _image!,
                        fit: BoxFit.fill,
                      ),
              ),
            )),
      ),
    );
  }
}
