import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'deleted_photo_id.dart';

class BoxDeletedPhotoId {
  final Box<DeletedPhotoId> boxDeletedPhotoIds =
      Hive.box<DeletedPhotoId>('deletedPhotoIds');

  nullRecordPhotoId(String photoId) {
    final DeletedPhotoId recordPhotoId = DeletedPhotoId(
        deletedTime: DateTime.now(), photoId: photoId, uuid: Uuid().v4());

    boxDeletedPhotoIds.add(recordPhotoId);
    for (var deletedPhotoId in boxDeletedPhotoIds.values.toList()) {
      print(deletedPhotoId.photoId);
      print(deletedPhotoId.deletedTime);
    }
  }

  deletedPhotoId() {
    int testCount = 0;
    List<DeletedPhotoId> deletedPhotoIds = boxDeletedPhotoIds.values.toList();

    // (DeletedPhotoIds) => {};
    print("sss ${boxDeletedPhotoIds.values.length}");
    for (DeletedPhotoId deletedPhotoId in deletedPhotoIds) {
      testCount++;
      print(deletedPhotoId.deletedTime.difference(DateTime.now()).inDays);
      bool timeLimit =
          DateTime.now().difference(deletedPhotoId.deletedTime).inDays.abs() >
              1;
      print(timeLimit);
      if (!timeLimit) {
        return;
      }

      print("object");

      // if (deletedPhotoId.deletedTime.difference(DateTime.now()).inDays >= 30) {}
    }
  }
}
