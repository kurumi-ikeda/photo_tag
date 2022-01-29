import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/home/image_screen.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';

import 'package:photo_manager/photo_manager.dart';

/*
テスト用widget

idからAssetEntityを作る

*/

class TestTagCreate extends StatefulWidget {
  final List<AssetEntity> selectedList;
  final String tagName;
  const TestTagCreate(
      {Key? key, required this.selectedList, required this.tagName})
      : super(key: key);

  @override
  _TestTagCreateState createState() => _TestTagCreateState();
}

class _TestTagCreateState extends State<TestTagCreate> {
  List<Uint8List?> imageList = [];
  List<AssetEntity> testList = [];

  addListAsset() async {
    var ids = [
      '6CA12454-6A3D-41BF-97D4-226A88AB205B/L0/001',
      '9C474BCB-9C3F-49E9-A1D2-0DBEFD323B8E/L0/001'
    ];
    var createAssetEntity =
        await AssetEntity.fromId('6CA12454-6A3D-41BF-97D4-226A88AB205B/L0/001');

    testList.add(createAssetEntity!);
  }

  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    // addTag();

    imageFormat();
  }

  // コンストラクタで受け取った変数をwidgetで表示できる形にする(多分)
  imageFormat() async {
    lastPage = currentPage;
    imageList = await Future.wait(
      widget.selectedList.map((e) => e.thumbDataWithSize(200, 200)).toList(),
    );

    setState(() {});
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        imageFormat();
      }
    }
  }

  // var imageList = await Future.wait(
  //       widget.selectedList.map((e) => e.thumbDataWithSize(200, 200)).toList(),
  //     );
  //wiget. で selectedList, tagNameアクセスできる
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tagName),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return false;
        },
        child: GridView.builder(
            itemCount: imageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              final asset = widget.selectedList[index];
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
            }),
      ),
    );
  }
}
