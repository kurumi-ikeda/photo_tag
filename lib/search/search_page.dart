import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/main_app_bar.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/library_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<Tag> tags = Boxes.getTags().values.toList();
  List<Tag> searchTagList = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(searchWordContains);
  }

  @override
  void dispose() {
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
    setState(() {
      if (controller.text.isEmpty) {
        return;
      }
      //空白文字区切り
      List<String> splitSearchWords = controller.text.split(RegExp(r'\s'));
      print(splitSearchWords);
      searchTagList = [];
      // String searchedWord
      if (controller.text.isNotEmpty) {
        for (String word in splitSearchWords) {
          for (int i = 0; i < tags.length; i++) {
            if (tags[i].tagName.contains(word) && word.isNotEmpty) {
              searchTagList.add(tags[i]);
            }
            // if (tags[i].tagName.contains(controller.text)) {
            //   searchTagList.add(tags[i]);
            // }
          }
        }
      }
      print(searchTagList);
    });
  }
  // aaa

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
    if (searchTagList.isNotEmpty) {
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
        itemCount: searchTagList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              controller.text = searchTagList[index].tagName + " ";
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
            },
            trailing: const Icon(
              Icons.north_west,
              color: Colors.grey,
            ),
            title: Text(searchTagList[index].tagName),
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
        itemCount: searchTagList.length,
        itemBuilder: (context, index) {
          return TagWidget(tag: searchTagList[index]);
        });
  }
}
