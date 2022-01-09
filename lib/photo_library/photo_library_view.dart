import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoLibraryView extends StatefulWidget {
  const PhotoLibraryView({Key? key}) : super(key: key);

  @override
  _PhotoLibraryViewState createState() => _PhotoLibraryViewState();
}

class _PhotoLibraryViewState extends State<PhotoLibraryView> {
  //作成されたタグ達
  var tags = [
    'タグ1',
    'タグ2',
    'タグ3',
    'タグ4',
    'タグ5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タグ'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0, // 縦スペース
          mainAxisSpacing: 20.0, //横スペース
        ),
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          final text = tags[index];
          return Container(
              alignment: Alignment.center,
              child: Text(text),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(right: 5, left: 5),
              // margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.green,
              ));
        },
      ),
    );
  }
}
