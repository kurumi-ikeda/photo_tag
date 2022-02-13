import 'dart:async';
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

class TagPage extends StatefulWidget {
  final Tag tag;
  const TagPage({Key? key, required this.tag}) : super(key: key);

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  bool isSelectionState = false;
  List<AssetEntity?> assetList = [];
  List<Uint8List?> imageList = [];
  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    Future(() async {
      await createAsset();
      await imageFormat();
    });
  }

  //idからAsset(写真)を作り出す
  createAsset() async {
    assetList = await Future.wait(
      widget.tag.photoIdList.map((e) => AssetEntity.fromId(e)),
    );
  }

  Future<Uint8List?> thumbnailCreation(Tag tag) async {
    String id = tag.photoIdList[0];
    AssetEntity? asset = await AssetEntity.fromId(id);
    var thumbnail = await asset!.thumbDataWithSize(200, 200);
    return thumbnail;
  }

  // Future addTag() async {
  //   final box = Boxes.getTags();

  //   Tag tag;
  //   final photoIdList = widget.selectedList.map((e) => e.id).toList();
  //   tag = Tag(photoIdList: photoIdList, tagName: widget.tagName);
  //   await box.add(tag);
  //   for (var tag in box.values.toList()) {
  //     print('tag name: ${tag.tagName}');
  //     print('photoIdList: ${tag.photoIdList}');
  //   }
  // }

  // コンストラクタで受け取った変数をwidgetで表示できる形にする(多分)
  imageFormat() async {
    lastPage = currentPage;
    imageList = await Future.wait(
      assetList.map((e) => e!.thumbDataWithSize(200, 200)).toList(),
    );

    setState(() {});
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        // imageFormat();
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
        title: Text(widget.tag.tagName),
        actions: <Widget>[
          PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: Text("写真編集"),
                    ),
                    PopupMenuItem(
                      child: const Text("名前変更"),
                      onTap: () async {
                        await Future.delayed(const Duration(seconds: 0));
                        final text = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return const EditDialog();
                          },
                        );
                        if (text?.isNotEmpty == true) {
                          widget.tag.tagName = text!;

                          await Boxes.updateTag(widget.tag);
                          setState(() {});
                        }
                      },
                    ),
                  ]),
        ],
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
      ),
    );
  }
}

class EditDialog extends StatefulWidget {
  const EditDialog({Key? key}) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('名前変更'),
      content: TextFormField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text('完了'),
        )
      ],
    );
  }
}
