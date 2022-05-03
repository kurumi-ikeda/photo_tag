import 'package:flutter_application_photo_tag/model/deleted_tag_photo_id/deleted_photo_id.dart';
import 'package:hive/hive.dart';

class BoxDeletedPhotoId {
  final Box<DeletedPhotoId> boxDeletedPhotoIds =
      Hive.box<DeletedPhotoId>('deletedPhotoIds');

  //
  nullRecordPhotoId(String photoId) {
    final DeletedPhotoId recordPhotoId =
        DeletedPhotoId(deletedTime: DateTime.now(), photoId: photoId);

    boxDeletedPhotoIds.add(recordPhotoId);
    for (var deletedPhotoId in boxDeletedPhotoIds.values.toList()) {
      print(deletedPhotoId.photoId);
      print(deletedPhotoId.deletedTime);
    }
  }
}
