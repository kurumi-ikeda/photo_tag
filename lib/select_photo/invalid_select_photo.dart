// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
// import 'package:flutter_application_photo_tag/tag_feature/tag.dart';

// import 'package:flutter_application_photo_tag/tag_feature/tag_create.dart';
// import 'package:flutter_application_photo_tag/tag_library/library_page.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'package:photo_manager/photo_manager.dart';

// class SelectPhoto extends StatefulWidget {
//   const SelectPhoto({Key? key}) : super(key: key);

//   @override
//   _SelectPhotoState createState() => _SelectPhotoState();
// }

// class _SelectPhotoState extends State<SelectPhoto> {
//   //タグの作成に使う名前
//   late String tagName;
//   //ここに選択したものが追加される
//   var selectedList = <AssetEntity>[];
//   //端末から写真を取得するためのList
//   List<AssetEntity> assetList = [];
//   List<Uint8List?> imageList = [];

//   int currentPage = 0;
//   late int lastPage;

//   @override
//   void initState() {
//     super.initState();
//     fetchNewMedia();
//   }

//   //スクロールをしてる処理？
//   _handleScrollEvent(ScrollNotification scroll) {
//     if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
//       if (currentPage != lastPage) {
//         fetchNewMedia();
//       }
//     }
//   }

//   fetchNewMedia() async {
//     lastPage = currentPage;
//     var result = await PhotoManager.requestPermission();
//     if (result) {
//       // success
//       //アルバムを最初に取得する
//       List<AssetPathEntity> albums =
//           await PhotoManager.getAssetPathList(onlyAll: true);
//       // print(albums);
//       assetList = await albums[0].getAssetListPaged(currentPage, 60);
//       //今まで取りにいっていたものを最初に取りに行く
//       imageList = await Future.wait(
//         assetList.map((e) => e.thumbDataWithSize(200, 200)).toList(),
//       );
//     } else {
//       PhotoManager.openSetting();
//     }
//     setState(() {});
//   }

//   //タグの名前と、選択した写真をTagCreateクラスに渡すメソッド
//   tagCreate(List<AssetEntity> selectedList, String tagName) {
//     // print("セレクトリスト  ${selectedList}");
//     if (tagName == "" || selectedList.isEmpty) {
//       return;
//     } else {
//       TagCreate().saveTag(selectedList, tagName);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Box<Tag>>(
//       valueListenable: Boxes.getTags().listenable(),
//       builder: (context, box, _) {
//         final tags = box.values.toList();
//         return Scaffold(
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(AppBar().preferredSize.height),
//             child: _SelectPhotoAppBar(selectedList: selectedList, tags: tags),
//           ),
//           body: NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification scroll) {
//               _handleScrollEvent(scroll);
//               return false;
//             },
//             child: GridView.builder(
//               itemCount: assetList.length,
//               gridDelegate:
//                   //写真を一列に何枚ずつ置くか決める
//                   const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3),
//               itemBuilder: (BuildContext context, int index) {
//                 final asset = assetList[index];
//                 final image = imageList[index];
//                 return InkWell(
//                   //押したら、selectedListに追加する
//                   onTap: () {
//                     if (selectedList.contains(asset)) {
//                       selectedList.remove(asset);
//                     } else {
//                       selectedList.add(asset);
//                     }
//                     setState(() {});
//                   },
//                   child: Stack(
//                     children: <Widget>[
//                       Positioned.fill(
//                         child: Image.memory(
//                           image!,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       //if文でビデオだったら、ビデオのアイコンを追加する
//                       if (asset.type == AssetType.video)
//                         const Align(
//                           alignment: Alignment.bottomRight,
//                           child: Padding(
//                             padding: EdgeInsets.only(right: 5, bottom: 5),
//                             child: Icon(
//                               Icons.videocam,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       //check_circleを反映している場所?
//                       if (selectedList
//                           .map((e) => e.id)
//                           .toList()
//                           .contains(asset.id))
//                         const Align(
//                           alignment: Alignment.bottomRight,
//                           child: Padding(
//                             //余白
//                             padding: EdgeInsets.all(4),
//                             child: Icon(
//                               Icons.check_circle,
//                               color: Colors.lightBlue,
//                             ),
//                           ),
//                         )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _SelectPhotoAppBar extends StatelessWidget {
//   const _SelectPhotoAppBar(
//       {Key? key, required this.tags, required this.selectedList})
//       : super(key: key);
//   final List<AssetEntity> selectedList;
//   final List<Tag> tags;

//   @override
//   Widget build(BuildContext context) {
//     var _screenSize = MediaQuery.of(context).size;
//     return AppBar(
//       actions: [
//         //ここがタグの名前を決める所
//         ElevatedButton(
//           onPressed: () async {
//             await showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return SizedBox(
//                   height: _screenSize.height,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Expanded(
//                         child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: _SelectPhotoCustomScrollView(
//                                 tags: tags, selectedList: selectedList)),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//           child: const Text('タグに追加'),
//         ),
//       ],
//     );
//   }
// }

// class _SelectPhotoCustomScrollView extends StatelessWidget {
//   const _SelectPhotoCustomScrollView(
//       {Key? key, required this.tags, required this.selectedList})
//       : super(key: key);
//   final List<AssetEntity> selectedList;
//   final List<Tag> tags;
//   tagCreate(List<AssetEntity> selectedList, String tagName) {
//     if (tagName == "" || selectedList.isEmpty) {
//       return;
//     } else {
//       TagCreate().saveTag(selectedList, tagName);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: <Widget>[
//         //新規作成用のSliverGrid
//         SliverGrid(
//           delegate: SliverChildBuilderDelegate(
//             //ここ別にBuildContext使わなくてよくね？と思いつつ時間がないので、一旦このままにします。
//             (BuildContext _, int __) {
//               return InkWell(
//                   onTap: () async {
//                     final result = await showDialog<String>(
//                       context: context,
//                       builder: (context) {
//                         return const _InputDialog();
//                       },
//                     );

//                     if (result == null || selectedList.isEmpty) {
//                       return;
//                     }

//                     tagCreate(selectedList, result);
//                     Navigator.of(context).popUntil((route) => route.isFirst);
//                   },
//                   child: Card(
//                     clipBehavior: Clip.antiAlias,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             color: const Color(0xFFc1c1c1),
//                           ),
//                         ),
//                         const ListTile(
//                           visualDensity:
//                               VisualDensity(horizontal: 0, vertical: -4),
//                           contentPadding:
//                               EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//                           title: Text("新規作成"),
//                           minLeadingWidth: 40,
//                         ),
//                       ],
//                     ),
//                   ));
//             },
//             childCount: 1,
//           ),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 20.0, // 縦スペース
//             mainAxisSpacing: 20.0, //横スペース
//           ),
//         ),
//         //すでにあるTagに追加する用
//         SliverGrid(
//           delegate: SliverChildBuilderDelegate(
//             (BuildContext context, int index) {
//               return InkWell(
//                 onTap: () {
//                   List<String> resultSelectedIdList = [];

//                   print(tags[index].photoIdList.length);

//                   List<String> selectedIdList =
//                       selectedList.map((e) => e.id).toList();
//                   for (String id in selectedIdList) {
//                     if (!tags[index].photoIdList.contains(id)) {
//                       resultSelectedIdList.add(id);
//                     }
//                   }

//                   //tagに選択した写真のidを追加
//                   tags[index].photoIdList.addAll(resultSelectedIdList);

//                   //変更内容を保存
//                   Boxes.updateTag(tags[index]);
//                   print(tags[index].photoIdList.length);

//                   Navigator.of(context).pop();
//                 },
//                 child: TagCard(tag: tags[index]),
//               );
//             },
//             childCount: tags.length,
//           ),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 20.0, // 縦スペース
//             mainAxisSpacing: 20.0, //横スペース
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _InputDialog extends StatefulWidget {
//   const _InputDialog({Key? key}) : super(key: key);

//   @override
//   _InputDialogState createState() => _InputDialogState();
// }

// class _InputDialogState extends State<_InputDialog> {
//   final controller = TextEditingController();
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('タグ追加'),
//       content: TextFormField(
//         controller: controller,
//         enabled: true,
//         maxLength: 15,
//       ),
//       actions: [
//         TextButton(
//           child: const Text('キャンセル'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         TextButton(
//             child: const Text("保存"),
//             onPressed: () {
//               final text = controller.text;
//               Navigator.of(context).pop(text);
//               Navigator.of(context).pop();
//             })
//       ],
//     );
//   }
// }
