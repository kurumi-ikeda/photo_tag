// ignore: file_names
// ignore: file_names
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'Image_Screen.dart';

class PhotoAcquisition {
  //写真を全部取得する
  static Future<List<AssetPathEntity>?> getPhotoAll() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      return albums;
    } else {
      PhotoManager.openSetting();
    }
  }
}
