import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/view/photoAccess/photo_acquisition.dart';
import 'package:photo_manager/photo_manager.dart';
import 'image_screen.dart';
import 'photo_acquisition.dart';

class PhotoHome extends StatefulWidget {
  @override
  _PhotoHomeState createState() => _PhotoHomeState();
}

class _PhotoHomeState extends State<PhotoHome> {
  //ここに選択したものが追加される
  var selectedList = <AssetEntity>[];
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
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
      //アルバムを最初に取得する
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      assetList = await albums[0].getAssetListPaged(currentPage, 60);
      //今まで取りにいっていたものを最初に取りに行く
      imageList = await Future.wait(
        assetList.map((e) => e.thumbDataWithSize(200, 200)).toList(),
      );

      print(assetList);
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
        gridDelegate:
            //写真を一列に何枚ずつ置くか決める
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          final asset = assetList[index];
          final image = imageList[index];
          return InkWell(
            //押したら、selectedListに追加する
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageScreen(imageFile: asset.file),
                  // TODO: navigate to Image/Video screen
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
                //

                //if文でビデオだったら、ビデオのアイコンを追加する
                if (asset.type == AssetType.video)
                  Align(
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
