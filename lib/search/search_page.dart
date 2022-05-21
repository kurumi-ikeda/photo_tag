import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/model/tag/box_tag.dart';
import 'package:flutter_application_photo_tag/widget/main_app_bar.dart';
import 'package:flutter_application_photo_tag/model/tag/tag.dart';

import 'package:flutter_application_photo_tag/tag_library/library_page.dart';
import 'package:photo_manager/photo_manager.dart';

import '../widget/image_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<Tag> tags = BoxTag().getTags().values.toList();
  Set<Tag> searchTagList = {};
  List<Uint8List?> imageList = [];
  List<AssetEntity?> assetList = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      assetList = await tagPhotoIdInMatch();
    });

    controller.addListener(addListenerProcess);
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
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverToBoxAdapter(
            child: _SearchTextField(controller: controller),
          ),
          SliverToBoxAdapter(
            child: _SuggestionListView(
              controller: controller,
              searchTagList: searchTagList.toList(),
            ),
          ),

          searchListSliverGridView(),
          // const SliverToBoxAdapter(
          //   child: Text("このTag達に含まれている写真"),
          // ),

          _PhotoSliverGridView(
            imageList: imageList,
            assetList: assetList,
          ),
        ],
      ),
    );
  }

  void addListenerProcess() async {
    searchWordContains();
    assetList = await tagPhotoIdInMatch();
    assetList.removeWhere((asset) => asset == null);

    if (assetList.isNotEmpty) {
      await _imageFormat();
    }
  }

  void searchWordContains() {
    setState(() {
      if (controller.text.isEmpty) {
        return;
      }
      //空白文字区切り
      List<String> splitSearchWords = controller.text.split(RegExp(r'\s'));
      searchTagList = {};

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

  _imageFormat() async {
    imageList = await Future.wait(
      assetList.map((e) => e!.thumbDataWithSize(200, 200)).toList(),
    );
    setState(() {});
  }

  Widget searchListSliverGridView() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return TagWidget(tag: searchTagList.elementAt(index));
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

  Future<List<AssetEntity?>> tagPhotoIdInMatch() async {
    if (searchTagList.isNotEmpty) {
      Set<String> matchPhotoIdList = {};

      Tag beforeSearchTag = searchTagList.elementAt(0);
      for (int i = 1; i < searchTagList.length; i++) {
        // Set<String> photoId = searchTagList[i].photoIdList.toSet();
        Set<String> photoId = searchTagList.elementAt(i).photoIdList.toSet();
        Set<String> beforePhotoId = beforeSearchTag.photoIdList.toSet();

        //互いのListに共通している要素をmatchedListに保存
        Set<String> matchedList = photoId.intersection(beforePhotoId);

        matchPhotoIdList = matchedList.intersection(matchedList);
        beforeSearchTag = searchTagList.elementAt(i);
      }

      // List<AssetEntity?> assetList = await Future.wait(
      //   matchPhotoIdList.map((e) => AssetEntity.fromId(e)),
      // );
      List<AssetEntity?> assetList =
          await createAsset(matchPhotoIdList.toList());

      return assetList;
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
}

class _SearchTextField extends StatelessWidget {
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
      // autofocus: true,
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

class _SuggestionListView extends StatelessWidget {
  const _SuggestionListView(
      {Key? key, required this.searchTagList, required this.controller})
      : super(key: key);
  final List<Tag> searchTagList;
  final TextEditingController controller;

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

  @override
  Widget build(BuildContext context) {
    return suggestionContainer(suggestionListView());
  }
}

class _PhotoSliverGridView extends StatefulWidget {
  const _PhotoSliverGridView(
      {Key? key, required this.assetList, required this.imageList})
      : super(key: key);

  final List<AssetEntity?> assetList;
  final List<Uint8List?> imageList;
  @override
  State<_PhotoSliverGridView> createState() => __PhotoSliverGridViewState();
}

class __PhotoSliverGridViewState extends State<_PhotoSliverGridView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (widget.assetList.length == widget.imageList.length) {
            final asset = widget.assetList[index];
            final image = widget.imageList[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImagePage(imageFile: asset!.file),
                  ),
                );
              },
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.memory(
                      image!,
                      fit: BoxFit.cover,
                    ),
                  ),

                  //if文でビデオだったら、ビデオのアイコンを追加する
                  if (asset!.type == AssetType.video)
                    const Align(
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
              ),
            );
          }
        },
        childCount: widget.imageList.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
    );
  }
}
