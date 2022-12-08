import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/model/deleted_tag_photo_id/box_deleted_photo_id.dart';
import 'package:flutter_application_photo_tag/model/tag/box_tag.dart';
import 'package:flutter_application_photo_tag/model/tag/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/tag_page/result_selection_provider.dart';
import 'package:flutter_application_photo_tag/tag_library/tag_page/tag_page.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../widget/photo_grid_component.dart';

class TagPhotoGridView extends StatefulWidget {
  const TagPhotoGridView({Key? key, required this.tag}) : super(key: key);

  final Tag tag;

  @override
  _TagPhotoGridViewState createState() => _TagPhotoGridViewState();
}

class _TagPhotoGridViewState extends State<TagPhotoGridView> {
  List<Uint8List?> imageList = [];
  List<AssetEntity?> assetList = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      await createAsset();
      assetList.removeWhere((asset) => asset == null);
      await _imageFormat();
    });
  }

  createAsset() async {
    assetList = await Future.wait(widget.tag.photoIdList.map((photoId) async {
      AssetEntity? asset = await AssetEntity.fromId(photoId);
      if (asset == null) {
        BoxDeletedPhotoId().nullRecordPhotoId(photoId);
      }

      return asset;
    }));
  }

  _imageFormat() async {
    imageList = await Future.wait(
      assetList.map((e) => e!.thumbDataWithSize(200, 200)).toList(),
    );

    setState(() {});
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.tag.tagName),
          actions: <Widget>[
            PopupMenuButton(
                itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const Text("写真編集"),
                        onTap: () {
                          context
                              .read<ResultSelectionProvider>()
                              .changeIsSelectionState();

                          setState(() {});
                        },
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
                            BoxTag().updateTag(widget.tag);

                            // await Boxes.updateTag(widget.tag);
                            setState(() {});
                          }
                        },
                      ),
                      PopupMenuItem(
                        child: const Text("このTagを削除"),
                        onTap: () async {
                          await BoxTag().deleteTag(widget.tag);
                          Navigator.pop(context);
                          setState(() {});
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
                return PhotoWidget(asset: asset, image: image);
              }),
        ));
  }
}
