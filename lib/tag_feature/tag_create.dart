import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/home/image_screen.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';

import 'package:photo_manager/photo_manager.dart';

/*
作るべきメソッド
tagnameの名前を替えられるメソッド(rename)
selectedListの中身を変更できるメソッド(rename)

*/

class TagCreate extends StatefulWidget {
  final List<AssetEntity> selectedList;
  final String tagName;
  const TagCreate({Key? key, required this.selectedList, required this.tagName})
      : super(key: key);

  @override
  _TagCreateState createState() => _TagCreateState();
}

class _TagCreateState extends State<TagCreate> {
  List<Uint8List?> imageList = [];
  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    addTag();

    imageFormat();
  }

  Future addTag() async {
    final box = Boxes.getTags();

    Tag tag;
    final photoIdList = widget.selectedList.map((e) => e.id).toList();
    tag = Tag(photoIdList: photoIdList, tagName: widget.tagName);
    await box.add(tag);
    for (var tag in box.values.toList()) {
      print('tag name: ${tag.tagName}');
      print('photoIdList: ${tag.photoIdList}');
    }
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
