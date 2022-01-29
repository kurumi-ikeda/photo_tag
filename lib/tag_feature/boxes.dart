import 'package:flutter_application_photo_tag/tag_feature/tag.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Tag> getTags() => Hive.box<Tag>('tags');
}
