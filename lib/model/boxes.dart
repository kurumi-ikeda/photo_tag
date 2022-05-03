import 'package:flutter_application_photo_tag/model/deleted_tag_photo_id/deleted_photo_id.dart';
import 'package:hive/hive.dart';

import 'tag_feature/tag.dart';

class Boxes {
  static Box<Tag> getTags() => Hive.box<Tag>('tags');

  static Future<void> updateTag(Tag tag) async {
    await getTags().put(tag.key, tag);
  }

  static deleteTag(Tag tag) async {
    await Boxes.getTags().delete(tag.key);
  }
}
