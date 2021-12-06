import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/view/photoAccess/PhotoAcquisition.dart';
import 'package:photo_manager/photo_manager.dart';
import 'Image_Screen.dart';
import 'PhotoAcquisition.dart';

class Serect_Potho extends StatefulWidget {
  @override
  _Serect_PothoState createState() => _Serect_PothoState();
}

class _Serect_PothoState extends State<Serect_Potho> {
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
              if (selectedList.contains(asset)) {
                selectedList.remove(asset);
              } else {
                selectedList.add(asset);
              }

              setState(() {});
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
                //check_circleを反映している場所?
                if (selectedList.map((e) => e.id).toList().contains(asset.id))
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      //余白
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.lightBlue,
                      ),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
