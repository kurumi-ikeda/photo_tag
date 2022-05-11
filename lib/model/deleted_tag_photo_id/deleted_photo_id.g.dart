// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_photo_id.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeletedPhotoIdAdapter extends TypeAdapter<DeletedPhotoId> {
  @override
  final int typeId = 2;

  @override
  DeletedPhotoId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeletedPhotoId(
      photoId: fields[10] as String,
      deletedTime: fields[12] as DateTime,
      uuid: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeletedPhotoId obj) {
    writer
      ..writeByte(3)
      ..writeByte(10)
      ..write(obj.photoId)
      ..writeByte(11)
      ..write(obj.uuid)
      ..writeByte(12)
      ..write(obj.deletedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeletedPhotoIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
