import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/main_app_bar.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/library_page.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController controller = TextEditingController();
  List<Tag> tags = Boxes.getTags().values.toList();
  List<int> searchIndexList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Column(
        children: [
          searchTextContainer(),
          searchListView(),
        ],
      ),
    );
  }

  Widget searchTextContainer() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        // border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: searchTextField(),
    );
  }

  Widget searchListView() {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0, // 縦スペース
          mainAxisSpacing: 20.0, //横スペース
        ),
        padding: const EdgeInsets.all(4),
        itemCount: searchIndexList.length,
        itemBuilder: (context, index) {
          index = searchIndexList[index];
          return TagWidget(tag: tags[index]);
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

      autofocus: true,
      style: const TextStyle(
        //テキストのスタイル
        color: Colors.black,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //キーボードのアクションボタンを指定
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          Icons.search_outlined,
          color: Colors.grey.withOpacity(0.9),
        ),
        //TextFiledのスタイル
        // enabledBorder: UnderlineInputBorder(
        // //デフォルトのTextFieldの枠線
        // borderSide: BorderSide(color: Colors.black)),
        // focusedBorder: UnderlineInputBorder(
        //TextFieldにフォーカス時の枠線
        // borderSide: BorderSide(color: Colors.black)),
        hintText: '写真、タグを検索', //何も入力してないときに表示されるテキスト
        hintStyle: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
