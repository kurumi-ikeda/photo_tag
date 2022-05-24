import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class AssetEntityList {
  AssetEntityList({required List<AssetEntity> assetList})
      : _assetList = assetList;
  final List<AssetEntity> _assetList;

  Future<List<Uint8List?>> imageFormat() async {
    List<Uint8List?> imageList = [];
    imageList = await Future.wait(
      _assetList.map((e) => e.thumbDataWithSize(200, 200)).toList(),
    );
    return imageList;
  }
}
