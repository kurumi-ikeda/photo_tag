import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController controller = TextEditingController();
  List<Tag> tags = Boxes.getTags().values.toList();
  List<int> searchIndexList = [];
  // final List<String> _list = [
  //   'English Textbook',
  //   'Japanese Textbook',
  //   'English Vocabulary',
  //   'Japanese Vocabulary'
  // ];

  @override
  void initState() {
    super.initState();
    // print(searchIndexList);
    // _list = Boxes.getTags().values.map((e) => e.tagName).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: defaultListView(),
      body: Column(
        children: [
          searchTextField(),
          // defaultListView(),
          searchListView(),
        ],
      ),
    );
  }

  Widget defaultListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tags.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(tags[index].tagName),
          ),
        );
      },
    );
  }

  Widget searchListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: searchIndexList.length,
        itemBuilder: (context, index) {
          index = searchIndexList[index];

          return Card(child: ListTile(title: Text(tags[index].tagName)));
        });
  }

  Widget searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          searchIndexList = [];
          for (int i = 0; i < tags.length; i++) {
            if (tags[i].tagName.contains(s)) {
              searchIndexList.add(i);
            }
          }
        });
      },
      autofocus: true, //TextFieldが表示されるときにフォーカスする（キーボードを表示する）
      // cursorColor: Colors.black, //カーソルの色
      style: const TextStyle(
        //テキストのスタイル
        color: Colors.black,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //キーボードのアクションボタンを指定
      decoration: const InputDecoration(
        //TextFiledのスタイル
        enabledBorder: UnderlineInputBorder(
            //デフォルトのTextFieldの枠線
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: UnderlineInputBorder(
            //TextFieldにフォーカス時の枠線
            borderSide: BorderSide(color: Colors.black)),
        hintText: '写真を検索', //何も入力してないときに表示されるテキスト
        hintStyle: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
