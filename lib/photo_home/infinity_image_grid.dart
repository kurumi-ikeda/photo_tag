import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/widget/chewie_video_page.dart';
import 'package:flutter_application_photo_tag/widget/main_app_bar.dart';

import 'package:photo_manager/photo_manager.dart';

import '../widget/image_page.dart';

class InfinityImageScrollPage extends StatefulWidget {
  const InfinityImageScrollPage({Key? key}) : super(key: key);

  @override
  _InfinityImageScrollPageState createState() =>
      _InfinityImageScrollPageState();
}

class _InfinityImageScrollPageState extends State<InfinityImageScrollPage> {
  final List<AssetEntity> _assetList = [];
  //写真一つ一つを読み込みための変数
  // final List<Widget> _mediaList = [];
  List<AssetPathEntity> albums = [];

  // int currentPage = 0;
  // late int lastPage;

  final int loadLength = 30;

  int _lastIndex = 0;

  @override
  void initState() {
    Future(() async {
      await init();
    });
    super.initState();
  }

  Future<void> init() async {
    await fetchAllPhoto();
    // await fetchNewMedia();
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

  Future<void> _getAssets() async {
    List<AssetEntity> _getAssetList = await albums[0]
        .getAssetListRange(start: _lastIndex, end: _lastIndex + loadLength);
    for (AssetEntity asset in _getAssetList) {
      _assetList.add(asset);
    }

    _lastIndex += loadLength;
  }

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return Container();
    }
    return Scaffold(
      appBar: const MainAppBar(),
      body: FutureBuilder(
        future: _getAssets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return InfinityImageGrid(
            assetList: _assetList,
            getAssets: _getAssets,
          );
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: const MainAppBar(),
  //       body: NotificationListener<ScrollNotification>(
  //           onNotification: (ScrollNotification scroll) {
  //             // _handleScrollEvent(scroll);
  //             return false;
  //           },
  //           child: GridView.builder(
  //               itemCount: _mediaList.length,
  //               //写真を一列に何枚ずつ置くか決める
  //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 3),
  //               itemBuilder: (BuildContext context, int index) {
  //                 return _mediaList[index];
  //               })));
  // }
}

class _ImageView extends StatelessWidget {
  final AssetEntity asset;
  const _ImageView({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
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
                          return ImagePage(imageFile: asset.file);
                        } else {
                          return ChewieVideoPage(videoFile: asset.file);
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
    );
  }
}

class InfinityImageGrid extends StatefulWidget {
  const InfinityImageGrid(
      {Key? key, required this.assetList, required this.getAssets})
      : super(key: key);
  final List<AssetEntity> assetList;
  final Future<void> Function() getAssets;

  @override
  State<InfinityImageGrid> createState() => _InfinityImageGridState();
}

class _InfinityImageGridState extends State<InfinityImageGrid> {
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !_isLoading) {
        _isLoading = true;
        await widget.getAssets();

        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.assetList.length,
        controller: _scrollController,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return _ImageView(asset: widget.assetList[index]);
        });
  }
}
