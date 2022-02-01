// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Velemenyek.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VelemenyekAdapter extends TypeAdapter<Velemenyek> {
  @override
  final int typeId = 2;

  @override
  Velemenyek read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Velemenyek(
      velemeny: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Velemenyek obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.velemeny);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VelemenyekAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
