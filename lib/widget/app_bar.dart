import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar app_Bar(BuildContext context, String head) {
  return AppBar(
    backgroundColor: Colors.blue,
    title: Text(head),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                  size: 30,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.bell,
                  color: Colors.white,
                  size: 30,
                )),
          ],
        ),
      ),
    ],
  );
}
