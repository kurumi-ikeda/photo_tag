import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:photo_manager/photo_manager.dart';

import 'image_screen.dart';

class TagPhotoGridView extends StatefulWidget {
  TagPhotoGridView({Key? key, required this.tag}) : super(key: key);
  Tag tag;

  @override
  _TagPhotoGridViewState createState() => _TagPhotoGridViewState();
}

class _TagPhotoGridViewState extends State<TagPhotoGridView> {
  int currentPage = 0;
  late int lastPage;
  List<Uint8List?> imageList = [];
  List<AssetEntity?> assetList = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      await createAsset();
      await _imageFormat();
    });
  }

  createAsset() async {
    assetList = await Future.wait(
      widget.tag.photoIdList.map((e) => AssetEntity.fromId(e)),
    );
  }

  _imageFormat() async {
    lastPage = currentPage;
    imageList = await Future.wait(
      assetList.map((e) => e!.thumbDataWithSize(200, 200)).toList(),
    );

    setState(() {});
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _imageFormat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return false;
      },
      child: GridView.builder(
          itemCount: imageList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            final asset = assetList[index];
            final image = imageList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageScreen(imageFile: asset!.file),
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
          }),
    );
  }
}
