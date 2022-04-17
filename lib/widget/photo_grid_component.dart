import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'chewie_video_page.dart';
import 'image_page.dart';

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({Key? key, required this.asset, required this.image})
      : super(key: key);
  final AssetEntity? asset;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (asset!.type == AssetType.image) {
                return ImagePage(imageFile: asset!.file);
              } else {
                return ChewieVideoPage(videoFile: asset!.file);
              }
            },
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.memory(
              image!,
              fit: BoxFit.cover,
            ),
          ),

          //if文でビデオだったら、ビデオのアイコンを追加する
          if (asset!.type == AssetType.video)
            const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 5, bottom: 5),
                child: Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
