import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'ImageScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Picker Example',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Media Picker Example App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _navIndex = 0;
  var _label = '';
  var _titles = ['insert_photo', 'photo_library', 'search'];
  var image_path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() {
              ;
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_photo),
            title: Text('insert_photo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_library,
            ),
            title: Text('photo_library'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('search'),
          ),
        ],
        onTap: (int index) {
          setState(
            () {
              _navIndex = index;
              _label = _titles[index];
            },
          );
        },
        currentIndex: _navIndex,
      ),
      body: MediaGrid(),
    );
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  //写真を読み込みための変数
  List<Widget> _mediaList = [];

  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  //スクロールをしてる処理？
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(currentPage, 100);
      print(media);

      List<Widget> temp = [];

      for (var asset in media) {
        temp.add(
          FutureBuilder<Uint8List?>(
            future: asset.thumbDataWithSize(200, 200),
            builder: (BuildContext context, snapshot) {
              // TODO: navigate to Image/Video screen

              if (snapshot.connectionState == ConnectionState.done)
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    //写真をタップするとその写真を表示する
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageScreen(imageFile: asset.file),
                            // TODO: navigate to Image/Video screen
                          ),
                        );
                      },
                    ),
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
                  ],
                );
              return Container();
            },
          ),
        );
      }

      setState(() {
        // _mediaList = media;
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return false;
        },
        child: GridView.builder(
            itemCount: _mediaList.length,
            gridDelegate:
                //写真を一列に何枚ずつ置くか決める
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return _mediaList[index];
            }));
  }
}
