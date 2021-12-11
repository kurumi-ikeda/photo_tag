import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/view/tag_feature/tag_create.dart';
import 'package:photo_manager/photo_manager.dart';

class SerectPotho extends StatefulWidget {
  const SerectPotho({Key? key}) : super(key: key);

  @override
  _SerectPothoState createState() => _SerectPothoState();
}

class _SerectPothoState extends State<SerectPotho> {
  //タグの作成に使う名前
  late String tagName;
  //ここに選択したものが追加される
  var selectedList = <AssetEntity>[];

  List<AssetEntity> assetList = [];
  List<Uint8List?> imageList = [];

  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    fetchNewMedia();
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
      // success
      //アルバムを最初に取得する
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      assetList = await albums[0].getAssetListPaged(currentPage, 60);
      //今まで取りにいっていたものを最初に取りに行く
      imageList = await Future.wait(
        assetList.map((e) => e.thumbDataWithSize(200, 200)).toList(),
      );

      print(assetList);
    } else {
      PhotoManager.openSetting();
    }
    setState(() {});
  }

  //タグの名前と、選択した写真をTagCreateクラスに渡すメソッド?
  makeTag(List<AssetEntity> selectedList, String tagName) {
    if (tagName == "") {
      return;
    } else {
      TagCreate(selectedList: selectedList, tagName: tagName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          //ここがタグの名前を決める所
          ElevatedButton(
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (contex) {
                  //ここから下をInputDialogに置き換える
                  return InputDialog();
                },
              );
              print(result);
              if (result == null && this.selectedList == null) {
                return;
              }

              // TagCreate(this.selectedList,result);
            },
            child: Text('タグを作成'),
          )
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
                  selectedList.add(asset);
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
                  //

                  //if文でビデオだったら、ビデオのアイコンを追加する
                  if (asset.type == AssetType.video)
                    Align(
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
          },
        ),
      ),
    );
  }
}

class InputDialog extends StatefulWidget {
  const InputDialog({Key? key}) : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('タグ追加'),
      content: TextFormField(
        controller: controller,
        enabled: true,
        maxLength: 15,
      ),

      actions: [
        FlatButton(
          child: Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
            child: Text("保存"),
            onPressed: () {
              final text = controller.text;
              Navigator.of(context).pop(text);
            })
      ],
      // actions: [
      //   TextButton(
      //     onPressed: () {
      //       final text = controller.text;
      //       print('入力された値: $text');

      //       // 値を返す。
      //       Navigator.of(context).pop(text);
      //     },
      //     child: const Text('保存'),
      //   )
      // ],
    );
  }
}

// AlertDialog(
//                     title: Text('タグ追加'),
//                     content: TextFormField(),
//                     actions: <Widget>[
//                       FlatButton(
//                         child: Text('キャンセル'),
//                         onPressed: () => Navigator.of(context).pop(0),
//                       ),
//                       FlatButton(
//                         child: Text('保存'),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   //ページ遷移はできたが、 tag_cleateへの画面遷移はまだできていない。
//                                   builder: (context) => const SerectPotho()));
//                         },
//                         // onPressed: () => Navigator.of(context).pop(1),
//                       ),
//                     ],
//                     },