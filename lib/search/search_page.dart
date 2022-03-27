import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/main_app_bar.dart';
import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:flutter_application_photo_tag/tag_library/library_page.dart';
import 'package:photo_manager/photo_manager.dart';

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
    tagPhotoIdInMatch();
    return Scaffold(
      appBar: const MainAppBar(),
      // CustomScrollView
      body: SingleChildScrollView(
        child: Column(
          children: [
            _SearchTextField(controller: controller),
            CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                  child: suggestionContainer(suggestionListView()),
                ),
                searchListSliverGridView(),
                // SliverToBoxAdapter(
                //   child: searchListGridView(),
                // ),

                // suggestionSilverListView(),
              ],
            ),

            // suggestionContainer(suggestionListView()),
            // searchListGridView(),
          ],
        ),
      ),
    );
  }

  void searchWordContains() {
    setState(() {
      if (controller.text.isEmpty) {
        return;
      }
      //空白文字区切り
      List<String> splitSearchWords = controller.text.split(RegExp(r'\s'));
      searchTagList = [];

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
    });
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

  // Widget suggestionSilverListView() {
  //   return SliverList(
  //       delegate: SliverChildBuilderDelegate(
  //     (BuildContext _, int index) {
  //       return ListTile(
  //         onTap: () {
  //           controller.text = searchTagList[index].tagName + " ";
  //           controller.selection = TextSelection.fromPosition(
  //               TextPosition(offset: controller.text.length));
  //         },
  //         trailing: const Icon(
  //           Icons.north_west,
  //           color: Colors.grey,
  //         ),
  //         title: Text(searchTagList[index].tagName),
  //         subtitle: Text(controller.text),
  //       );
  //     },
  //     childCount: searchTagList.length,
  //   ));
  // }

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

  Widget searchListSliverGridView() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return TagWidget(tag: searchTagList[index]);
        },
        childCount: searchTagList.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0, // 縦スペース
        mainAxisSpacing: 20.0, //横スペース
      ),
    );
  }

  Widget searchListGridView() {
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

  Future<List<AssetEntity?>> tagPhotoIdInMatch() async {
    if (searchTagList.isNotEmpty) {
      List<String> matchPhotoIdList = [];

      //自分の想像してた挙動と違うけど、動くからヨシ！！
      //多分matchPhotoIdListとmatchedListも比較しなきゃいけない気がする
      Tag beforeSearchTag = searchTagList[0];
      for (int i = 1; i < searchTagList.length; i++) {
        Set<String> photoId = searchTagList[i].photoIdList.toSet();
        Set<String> beforePhotoId = beforeSearchTag.photoIdList.toSet();
        //互いのListに共通している要素をmatchedListに保存
        Set<String> matchedList = photoId.intersection(beforePhotoId);
        // print(matchedList.toString() + "a");
        matchPhotoIdList.addAll(matchedList);
        beforeSearchTag = searchTagList[i];
      }
      print(matchPhotoIdList);

      // List<AssetEntity?> assetList = await Future.wait(
      //   matchPhotoIdList.map((e) => AssetEntity.fromId(e)),
      // );
      List<AssetEntity?> assetList = await createAsset(matchPhotoIdList);
      // print(" ${matchPhotoIdList.length}");

      return assetList;
      // searchTagList.length
    } else {
      List<AssetEntity?> emptyList = [];
      return emptyList;
    }
  }

  Future<List<AssetEntity?>> createAsset(List<String> photoIdList) async {
    List<AssetEntity?> assetList = await Future.wait(
      photoIdList.map((e) => AssetEntity.fromId(e)),
    );
    return assetList;
  }

  Widget photoMatchInView() {
    return Container();
  }
}

class _SearchTextField extends StatelessWidget {
  //   final Tag tag;
  // const TagCard({Key? key, required this.tag}) : super(key: key);
  final TextEditingController controller;

  const _SearchTextField({Key? key, required this.controller})
      : super(key: key);

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
        hintText: '写真、タグを検索', //何も入力してないときに表示されるテキスト
        hintStyle: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return searchTextContainer(searchTextField());
  }
}

// slivers: <Widget>[
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
