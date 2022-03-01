import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/tag_page/result_selection_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/src/provider.dart';

class SerectPhotoGridView extends StatefulWidget {
  SerectPhotoGridView({Key? key, required this.tag}) : super(key: key);
  Tag tag;

  @override
  _SerectPhotoGridViewState createState() => _SerectPhotoGridViewState();
}

class _SerectPhotoGridViewState extends State<SerectPhotoGridView> {
  final MaterialColor serectStateColor = Colors.lightBlue;
  //ここに選択したものが追加される
  var selectedList = <AssetEntity>[];
  //端末から写真を取得するためのList
  List<AssetEntity?> assetList = [];
  List<Uint8List?> imageList = [];

  int currentPage = 0;
  late int lastPage;

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: serectStateColor),
        centerTitle: true,
        title: Text(widget.tag.tagName),
        leading: IconButton(
          icon: const Icon(
            Icons.close_outlined,
          ),
          onPressed: () {
            context.read<ResultSelectionProvider>().changeIsSelectionState();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_horiz_outlined,
              color: serectStateColor,
            ),
            onPressed: () async {
              var result = await showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: const Text('tagから削除'),
                        onTap: () async {
                          for (var serectAsset in selectedList) {
                            assetList.remove(serectAsset);
                          }
                          final photoIdList =
                              assetList.map((e) => e!.id).toList();
                          widget.tag.photoIdList = photoIdList;
                          Boxes.updateTag(widget.tag);
                          setState(() {});
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return false;
        },
        child: GridView.builder(
          itemCount: assetList.length,
          gridDelegate:
              //写真を一列に何枚ずつ置くか決める
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            final asset = assetList[index];
            final image = imageList[index];
            return InkWell(
              //押したら、selectedListに追加する
              onTap: () {
                if (selectedList.contains(asset)) {
                  selectedList.remove(asset);
                } else {
                  selectedList.add(asset!);
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
                  //check_circleを反映している場所?
                  if (selectedList.map((e) => e.id).toList().contains(asset.id))
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        //余白
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.check_circle,
                          color: serectStateColor,
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
