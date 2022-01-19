import 'package:hive/hive.dart';
import 'package:photo_manager/photo_manager.dart';

part 'tag.g.dart';

@HiveType(typeId: 1)
class Tag {
  Tag({required this.selectedList, required this.tagName});
  @HiveField(0)
  late String tagName;

  @HiveField(1)
  late List<AssetEntity> selectedList;
}
