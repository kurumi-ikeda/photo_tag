import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'image_screen.dart';
// import 'package:flutter_application_photo_tag/view/photoAccess/photo_acquisition.dart';

import 'package:photo_manager/photo_manager.dart';

class PhotoHome extends StatefulWidget {
  const PhotoHome({Key? key}) : super(key: key);

  @override
  _PhotoHomeState createState() => _PhotoHomeState();
}

class _PhotoHomeState extends State<PhotoHome> {
  //ここに選択したものが追加される

  List<AssetEntity> assetList = [];
  List<Uint8List?> imageList = [];
  // List<AssetPathEntity> albums = [];

  // final selectedImageList = <AssetPathEntity>[];
  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    fetchNewMedia();
  }

  //スクロールをしてる処理？
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        fetchNewMedia();
      }
    }
  }

  fetchNewMedia() async {
    lastPage = currentPage;
    bool result = await PhotoManager.requestPermission();
    if (result) {
      //アルバムを最初に取得する
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      assetList = await albums[0].getAssetListPaged(currentPage, 60);
      print("${assetList.length} aaa ${assetList}, ${assetList.length}");
      //今まで取りにいっていたものを最初に取りに行く
      imageList = await Future.wait(
        assetList.map((e) => e.thumbDataWithSize(200, 200)).toList(),
      );
      print(imageList);

      // print(assetList);
    } else {
      //
      PhotoManager.openSetting();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return false;
      },
      child: GridView.builder(
        itemCount: assetList.length,
        //写真を一列に何枚ずつ置くか決める
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          final asset = assetList[index];
          final image = imageList[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageScreen(imageFile: asset.file),
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
                if (asset.type == AssetType.video)
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
        },
      ),
    );
  }
}
