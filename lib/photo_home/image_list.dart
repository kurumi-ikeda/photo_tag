import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/chewie_video_screen.dart';
import 'package:flutter_application_photo_tag/main_app_bar.dart';

import 'package:photo_manager/photo_manager.dart';

import '../image_screen.dart';

class PhotoHomePage extends StatefulWidget {
  const PhotoHomePage({Key? key}) : super(key: key);

  @override
  _PhotoHomePageState createState() => _PhotoHomePageState();
}

class _PhotoHomePageState extends State<PhotoHomePage> {
  //写真一つ一つを読み込みための変数
  final List<Widget> _mediaList = [];
  List<AssetPathEntity> albums = [];

  // final selectedImageList = <AssetPathEntity>[];
  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await fetchAllPhoto();
    await fetchNewMedia();
  }

  //写真全体を追加
  Future<void> fetchAllPhoto() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      albums = await PhotoManager.getAssetPathList(onlyAll: true);
    } else {
      PhotoManager.openSetting();
    }

    setState(() {});
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
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(currentPage, 100);
      // print(media);

      List<Widget> temp = [];

      for (var asset in media) {
        temp.add(
          FutureBuilder<Uint8List?>(
            future: asset.thumbDataWithSize(200, 200),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if (asset.type == AssetType.image) {
                                return ImageScreen(imageFile: asset.file);
                              } else {
                                return ChewieVideoScreen(videoFile: asset.file);
                              }
                            },
                          ),
                        );
                      },
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
                );
              }
              return Container();
            },
          ),
        );
      }

      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainAppBar(),
        body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scroll) {
              _handleScrollEvent(scroll);
              return false;
            },
            child: GridView.builder(
                itemCount: _mediaList.length,
                //写真を一列に何枚ずつ置くか決める
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return _mediaList[index];
                })));
  }
}
