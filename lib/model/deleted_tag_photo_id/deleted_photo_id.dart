import 'package:hive/hive.dart';
part 'deleted_photo_id.g.dart';

///Tagクラスに保存している [photoId] が、[AssetEntity.fromId()] をしたときにnullだったものを30日間保存しておくクラス
@HiveType(typeId: 2)
class DeletedPhotoId {
  DeletedPhotoId({required this.photoId, required this.deletedTime});

  @HiveField(10)
  late String photoId;
  @HiveField(11)
  late DateTime deletedTime;
}
