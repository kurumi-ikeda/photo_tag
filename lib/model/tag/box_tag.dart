import 'package:hive/hive.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

import 'tag.dart';

class BoxTag {
  final Box<Tag> _boxTag = Hive.box<Tag>('tags');

  Box<Tag> getTags() => _boxTag;

  createTag(List<AssetEntity> selectedList, String tagName) async {
    final photoIdList = selectedList.map((e) => e.id).toList();
    // 自分でkeyを作る
    final key = const Uuid().v4();
    Tag tag = Tag(key: key, photoIdList: photoIdList, tagName: tagName);
    // keyを指定して保存
    await _boxTag.put(key, tag);
    //デバック用
    // for (var tag in box.values.toList()) {
    //   print('tag name: ${tag.tagName}');
    //   print('photoIdList: ${tag.photoIdList}');
    // }
  }

  Future<void> updateTag(Tag tag) async {
    await _boxTag.put(tag.key, tag);
  }

  deleteTag(Tag tag) async {
    await _boxTag.delete(tag.key);
  }
}
