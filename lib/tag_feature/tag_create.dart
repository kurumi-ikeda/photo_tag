import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class TagCreate extends StatefulWidget {
  final List<AssetEntity> selectedList;
  final String tagName;
  const TagCreate({Key? key, required this.selectedList, required this.tagName})
      : super(key: key);

  @override
  _TagCreateState createState() => _TagCreateState();
}

class _TagCreateState extends State<TagCreate> {
  //wiget. で selectedList, required this.tagNameアクセスできるっぽい
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tagName),
      ),
    );
  }
}