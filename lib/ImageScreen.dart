import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  final Future<File?> imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: FutureBuilder<File?>(
        future: imageFile,
        builder: (_, snapshot) {
          final file = snapshot.data;
          if (file == null) return Container();
          // file.path
          return Image.file(file);
        },
      ),
    );
  }
}
