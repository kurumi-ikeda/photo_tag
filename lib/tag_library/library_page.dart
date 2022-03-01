import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/tag_page/tag_page.dart';
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('タグライブラリー'),
        ),
        body: ValueListenableBuilder<Box<Tag>>(
          valueListenable: Boxes.getTags().listenable(),
          builder: (context, box, _) {
            final tags = box.values.toList();
            return ImageWithTagGridView(tags: tags);
          },
        ),
      );
}

class ImageWithTagGridView extends StatelessWidget {
  const ImageWithTagGridView({Key? key, required this.tags}) : super(key: key);
  final List<Tag> tags;
  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const Center(
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
        padding: const EdgeInsets.all(4),
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          final tag = tags[index];

          return TagWidget(tag: tag);
        },
      );
    }
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({Key? key, required this.tag}) : super(key: key);
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TagPage(tag: tag)),
            ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              tag.photoIdList.isNotEmpty
                  ? Expanded(
                      child: FutureBuilder(
                        future: thumbnailCreation(tag),
                        builder: (BuildContext context,
                            AsyncSnapshot<Uint8List?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              constraints: const BoxConstraints.expand(),
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return const Center();
                        },
                      ),
                    )
                  : Expanded(
                      child: Container(
                        color: const Color(0xFFc1c1c1),
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
        ));
  }
}

Future<Uint8List?> thumbnailCreation(Tag tag) async {
  String id = tag.photoIdList[0];
  AssetEntity? asset = await AssetEntity.fromId(id);
  var thumbnail = await asset!.thumbDataWithSize(200, 200);
  return thumbnail;
}
