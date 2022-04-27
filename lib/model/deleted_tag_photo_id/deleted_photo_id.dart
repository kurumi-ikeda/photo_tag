import 'package:hive/hive.dart';

import '../boxes.dart';
part 'deleted_photo_id.g.dart';

///Tagクラスに保存している [photoId] が、[AssetEntity.fromId()] をしたときにnullだったものを30日間保存しておくクラス
@HiveType(typeId: 2)
class DeletedPhotoId {
  DeletedPhotoId({required this.photoId, required this.deletedTime});

  @HiveField(10)
  late String photoId;
  @HiveField(11)
  late DateTime deletedTime;

  static nullRecordPhotoId(String photoId) {
    final DeletedPhotoId recordPhotoId =
        DeletedPhotoId(deletedTime: DateTime.now(), photoId: photoId);
    Boxes.getDeletedPhotoIds().add(recordPhotoId);
    for (var deletedPhotoId in Boxes.getDeletedPhotoIds().values.toList()) {
      print(deletedPhotoId.photoId);
      print(deletedPhotoId.deletedTime);
    }
    //     for (var tag in box.values.toList()) {
    //   print('tag name: ${tag.tagName}');
    //   print('photoIdList: ${tag.photoIdList}');
    // }
  }
}
