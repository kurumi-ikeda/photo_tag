import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/model/tag/box_tag.dart';
import 'package:flutter_application_photo_tag/model/tag/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/library_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectPhoto extends StatefulWidget {
  const SelectPhoto({Key? key}) : super(key: key);

  @override
  _SelectPhotoState createState() => _SelectPhotoState();
}

class _SelectPhotoState extends State<SelectPhoto> {
  //写真一つ一つを読み込みための変数
  final List<_PhotoAsset> _mediaList = [];
  List<AssetPathEntity> albums = [];

  late String tagName;
  //ここに選択したものが追加される
  var selectedList = <AssetEntity>[];
  //端末から写真を取得するためのList
  List<AssetEntity> assetList = [];
  List<Uint8List?> imageList = [];

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

  fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetEntity> assetList =
          await albums[0].getAssetListPaged(currentPage, 100);
      // print(media);

      List<_PhotoAsset> temp = [];

      for (AssetEntity asset in assetList) {
        temp.add(_PhotoAsset(asset: asset));
      }

      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  //スクロールをしてる処理？
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        fetchNewMedia();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Tag>>(
        valueListenable: BoxTag().getTags().listenable(),
        builder: (context, box, _) {
          final tags = box.values.toList();
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child:
                    _SelectPhotoAppBar(selectedList: selectedList, tags: tags),
              ),
              body: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scroll) {
                    _handleScrollEvent(scroll);
                    return false;
                  },
                  child: GridView.builder(
                      itemCount: _mediaList.length,
                      //写真を一列に何枚ずつ置くか決める
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          // 押したら、selectedListに追加する
                          onTap: () {
                            if (selectedList
                                .contains(_mediaList[index].asset)) {
                              selectedList.remove(_mediaList[index].asset);
                            } else {
                              selectedList.add(_mediaList[index].asset);
                            }
                            setState(() {});
                          },

                          child: Stack(
                            children: [
                              _mediaList[index],
                              //check_circleを反映している場所?
                              if (selectedList
                                  .map((e) => e.id)
                                  .toList()
                                  .contains(_mediaList[index].asset.id))
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
                      })));
        });
  }
}

class _PhotoAsset extends StatelessWidget {
  final AssetEntity asset;
  const _PhotoAsset({Key? key, required this.asset}) : super(key: key);

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
              Stack(
                children: <Widget>[
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
            ],
          );
        }
        return Container();
      },
    );
  }
}

class _SelectPhotoAppBar extends StatelessWidget {
  const _SelectPhotoAppBar(
      {Key? key, required this.tags, required this.selectedList})
      : super(key: key);
  final List<AssetEntity> selectedList;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    return AppBar(
      actions: [
        //ここがタグの名前を決める所
        ElevatedButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: _screenSize.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _SelectPhotoCustomScrollView(
                                tags: tags, selectedList: selectedList)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Text('タグに追加'),
        ),
      ],
    );
  }
}

class _SelectPhotoCustomScrollView extends StatelessWidget {
  const _SelectPhotoCustomScrollView(
      {Key? key, required this.tags, required this.selectedList})
      : super(key: key);
  final List<AssetEntity> selectedList;
  final List<Tag> tags;

  tagCreate(List<AssetEntity> selectedList, String tagName) {
    BoxTag().createTag(selectedList, tagName);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        //新規作成用のSliverGrid
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            //ここ別にBuildContext使わなくてよくね？と思いつつ時間がないので、一旦このままにします。
            (BuildContext _, int __) {
              //新規作成のwidget
              return InkWell(
                  onTap: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return const _InputDialog();
                      },
                    );

                    // if (result == null || selectedList.isEmpty) {
                    //   return;
                    // }

                    if (result == null || result.isEmpty) {
                      return;
                    }

                    tagCreate(selectedList, result);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: const Color(0xFFc1c1c1),
                          ),
                        ),
                        const ListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          title: Text("新規作成"),
                          minLeadingWidth: 40,
                        ),
                      ],
                    ),
                  ));
            },
            childCount: 1,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0, // 縦スペース
            mainAxisSpacing: 20.0, //横スペース
          ),
        ),
        //すでにあるTagに追加する用
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  List<String> resultSelectedIdList = [];

                  List<String> selectedIdList =
                      selectedList.map((e) => e.id).toList();

                  for (String id in selectedIdList) {
                    if (!tags[index].photoIdList.contains(id)) {
                      resultSelectedIdList.add(id);
                    }
                  }

                  //tagに選択した写真のidを追加
                  tags[index].photoIdList.addAll(resultSelectedIdList);

                  //変更内容を保存
                  BoxTag().updateTag(tags[index]);

                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: TagCard(tag: tags[index]),
              );
            },
            childCount: tags.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0, // 縦スペース
            mainAxisSpacing: 20.0, //横スペース
          ),
        ),
      ],
    );
  }
}

class _InputDialog extends StatefulWidget {
  const _InputDialog({Key? key}) : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<_InputDialog> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('タグ追加'),
      content: TextFormField(
        controller: controller,
        enabled: true,
        maxLength: 15,
      ),
      actions: [
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
            child: const Text("保存"),
            onPressed: () {
              final text = controller.text;
              Navigator.of(context).pop(text);
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
