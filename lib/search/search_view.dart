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
  // List<Tag>

  @override
  void initState() {
    super.initState();
    controller.addListener(searchWordContains);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("$searchIndexList"),
            searchTextContainer(searchTextField()),
            suggestionContainer(suggestionListView()),
            searchListView(),
          ],
        ),
      ),
    );
  }

  Widget searchTextContainer(TextField textField) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
        // bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        // border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: textField,
    );
  }

  void searchWordContains() {
    // print(searchIndexList);
    setState(() {
      searchIndexList = [];
      if (controller.text.isNotEmpty) {
        for (int i = 0; i < tags.length; i++) {
          print(controller.text);
          if (tags[i].tagName.contains(controller.text)) {
            searchIndexList.add(i);
            print(searchIndexList);
          }
        }
      }
    });
  }

  TextField searchTextField() {
    return TextField(
      controller: controller,

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

  Widget suggestionContainer(Widget suggestionListView) {
    //このif文がないと、Containerのborderが表示してしまう。
    if (searchIndexList.isNotEmpty) {
      return Container(
          margin: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            // color: Colors.grey.withOpacity(0.2),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: suggestionListView);
    } else {
      return Container();
    }
  }

  Widget suggestionListView() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: searchIndexList.length,
        itemBuilder: (context, index) {
          index = searchIndexList[index];
          return ListTile(
            onTap: () {
              controller.text = tags[index].tagName + " ";
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
              // controller.addListener(tags[index].tagName);
            },
            trailing: const Icon(
              Icons.north_west,
              color: Colors.grey,
            ),
            title: Text(tags[index].tagName),
            subtitle: Text(controller.text),
          );
        });
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
}
