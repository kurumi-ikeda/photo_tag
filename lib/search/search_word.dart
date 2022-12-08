import 'package:flutter/material.dart';
import 'package:flutter_application_photo_tag/model/tag/tag.dart';

//SearchPageの検索するロジックを分離させたclass
class SearchWord {
  Set<Tag> searchWordContains(
    final TextEditingController controller,
    final List<Tag> tags,
  ) {
    if (controller.text.isEmpty) {
      final Set<Tag> setTag = {};
      return setTag;
    }

    //空白文字区切り
    final List<String> splitSearchWords = controller.text.split(RegExp(r'\s'));
    //初期化
    final Set<Tag> searchTagList = {};

    if (!controller.text.isNotEmpty) {
      final Set<Tag> setTag = {};
      return setTag;
    }
    for (String word in splitSearchWords) {
      for (int i = 0; i < tags.length; i++) {
        if (tags[i].tagName.contains(word) && word.isNotEmpty) {
          searchTagList.add(tags[i]);
        }
      }
    }
    return searchTagList;
  }
}
