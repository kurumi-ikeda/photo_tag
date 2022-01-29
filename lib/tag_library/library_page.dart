import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

class TagLibraryView extends StatefulWidget {
  const TagLibraryView({Key? key}) : super(key: key);

  @override
  _TagLibraryViewState createState() => _TagLibraryViewState();
}

class _TagLibraryViewState extends State<TagLibraryView> {
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List?> thumbnailCreation(Tag tag) async {
    String id = tag.photoIdList[0];
    AssetEntity? asset = await AssetEntity.fromId(id);
    var thumbnail = await asset!.thumbDataWithSize(200, 200);
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('タグライブラリー'),
        ),
        body: ValueListenableBuilder<Box<Tag>>(
          valueListenable: Boxes.getTags().listenable(),
          builder: (context, box, _) {
            final tags = box.values.toList().cast<Tag>();
            return (buildContent(tags));
          },
        ),
      );
  Widget buildContent(List<Tag> tags) {
    if (tags.isEmpty) {
      return Center(
        child: Text(
          'まだタグが一つもないよ！',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0, // 縦スペース
          mainAxisSpacing: 20.0, //横スペース
        ),
        padding: EdgeInsets.all(8),
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          final tag = tags[index];

          return buildTag(context, tag);
        },
      );
    }
  }

  Widget buildTag(
    BuildContext context,
    Tag tag,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: thumbnailCreation(tag),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    constraints: const BoxConstraints.expand(),
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.fill,
                    ),
                  );
                }
                return Text('${snapshot.data}');
              },
            ),
          ),
          // if (false) const CircularProgressIndicator(),
          ListTile(
            // leading: Icon(Icons.arrow_drop_down_circle),
            title: Text(tag.tagName),
            subtitle: Text(
              '${tag.photoIdList.length}個',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
