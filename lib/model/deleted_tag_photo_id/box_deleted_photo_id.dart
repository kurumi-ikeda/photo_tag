import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'deleted_photo_id.dart';

class BoxDeletedPhotoId {
  final Box<DeletedPhotoId> _boxDeletedPhotoIds =
      Hive.box<DeletedPhotoId>('deletedPhotoIds');

  nullRecordPhotoId(final String photoId) {
    final DeletedPhotoId recordPhotoId = DeletedPhotoId(
        deletedTime: DateTime.now(), photoId: photoId, uuid: const Uuid().v4());

    _boxDeletedPhotoIds.add(recordPhotoId);
    for (var deletedPhotoId in _boxDeletedPhotoIds.values.toList()) {
      print(deletedPhotoId.photoId);
      print(deletedPhotoId.deletedTime);
    }
  }

  periodDeletedPhotoId() {
    final List<DeletedPhotoId> deletedPhotoIds =
        _boxDeletedPhotoIds.values.toList();

    // (DeletedPhotoIds) => {};
    print("sss ${_boxDeletedPhotoIds.values.length}");
    for (DeletedPhotoId deletedPhotoId in deletedPhotoIds) {
      print(deletedPhotoId.deletedTime.difference(DateTime.now()).inDays);
      // TODO: あとで、1を31にすること
      final bool timeLimit =
          DateTime.now().difference(deletedPhotoId.deletedTime).inDays.abs() >
              1;
      print(timeLimit);

      //早期return
      if (!timeLimit) {
        continue;
      }
      _deletedPhotoId(deletedPhotoId);

      // if (deletedPhotoId.deletedTime.difference(DateTime.now()).inDays >= 30) {}
    }
  }

  _deletedPhotoId(final DeletedPhotoId deletedPhotoId) async {
    await _boxDeletedPhotoIds.delete(deletedPhotoId.uuid);
  }
  // deleteTag(Tag tag) async {
  //   await _boxTag.delete(tag.key);
  // }
}
