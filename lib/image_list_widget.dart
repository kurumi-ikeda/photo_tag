// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_photo_tag/view/photoAccess/PhotoAcquisition.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'ImageScreen.dart';
// import 'PhotoAcquisition.dart';

// class ImageListWidget extends StatefulWidget {
//   @override
//   _ImageListWidgetState createState() => _ImageListWidgetState();
// }

// class _ImageListWidgetState extends State<ImageListWidget> {
//   //写真一つ一つを読み込みための変数
//   List<Widget> _mediaList = [];
//   List<AssetPathEntity> albums = [];

//   // final selectedImageList = <AssetPathEntity>[];
//   int currentPage = 0;
//   late int lastPage;

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   Future<void> init() async {
//     await fetechAllPhoto();
//     await fetchNewMedia();
//   }

//   //写真全体を追加
//   Future<void> fetechAllPhoto() async {
//     albums = (await PhotoAcquisition.getPhotoAll()) ?? [];
//     setState(() {});
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
//       List<AssetEntity> media =
//           await this.albums[0].getAssetListPaged(currentPage, 30);
//       // print(media);

//       List<Widget> temp = [];

//       for (var asset in media) {
//         temp.add(
//           FutureBuilder<Uint8List?>(
//             future: asset.thumbDataWithSize(200, 200),
//             builder: (BuildContext context, snapshot) {
//               // TODO: navigate to Image/Video screen

//               if (snapshot.connectionState == ConnectionState.done)
//                 return Stack(
//                   children: <Widget>[
//                     Positioned.fill(
//                       child: Image.memory(
//                         snapshot.data!,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     //写真をタップするとその写真を表示する
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ImageScreen(imageFile: asset.file),
//                             // TODO: navigate to Image/Video screen
//                           ),
//                         );
//                       },
//                     ),

//                     //if文でビデオだったら、ビデオのアイコンを追加する
//                     if (asset.type == AssetType.video)
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: Padding(
//                           padding: EdgeInsets.only(right: 5, bottom: 5),
//                           child: Icon(
//                             Icons.videocam,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               return Container();
//             },
//           ),
//         );
//       }

//       setState(() {
//         _mediaList.addAll(temp);
//         currentPage++;
//       });
//     } else {
//       PhotoManager.openSetting();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scroll) {
//           _handleScrollEvent(scroll);
//           return false;
//         },
//         child: GridView.builder(
//             itemCount: _mediaList.length,
//             gridDelegate:
//                 //写真を一列に何枚ずつ置くか決める
//                 SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//             itemBuilder: (BuildContext context, int index) {
//               return _mediaList[index];
//             }));
//   }
// }
