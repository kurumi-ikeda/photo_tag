import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 1)
class Tag {
  Tag({required this.key, required this.photoIdList, required this.tagName});
  @HiveField(0)
  late String key;

  @HiveField(1)
  late String tagName;

  @HiveField(2)
  late List<String> photoIdList = [];

  @override
  String toString() {
    return "tagName: " +
        tagName +
        " " +
        "idsCount: " +
        photoIdList.length.toString();
  }
}
