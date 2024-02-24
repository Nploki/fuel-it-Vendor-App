import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectedImage extends StatelessWidget {
  final String? imageUrl;

  const SelectedImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              },
            )
          : const Center(
              child: Text('Select Image'),
            ),
    );
  }
}
