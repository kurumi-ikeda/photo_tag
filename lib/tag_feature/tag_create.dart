import 'package:flutter_application_photo_tag/tag_feature/boxes.dart';
import 'package:flutter_application_photo_tag/tag_feature/tag.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

/*
作るべきメソッド
tagNameの名前を替えられるメソッド(rename)
selectedListの中身を変更できるメソッド(rename)

*/

class TagCreate {
  saveTag(List<AssetEntity> selectedList, String tagName) async {
    final box = Boxes.getTags();

    Tag tag;
    final photoIdList = selectedList.map((e) => e.id).toList();
    // 自分でkeyを作る
    final key = const Uuid().v4();
    tag = Tag(key: key, photoIdList: photoIdList, tagName: tagName);
    // keyを指定して保存
    await box.put(key, tag);
    //デバック用
    // for (var tag in box.values.toList()) {
    //   print('tag name: ${tag.tagName}');
    //   print('photoIdList: ${tag.photoIdList}');
    // }
  }
}
