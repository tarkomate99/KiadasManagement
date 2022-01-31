// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Kiadasok.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KiadasokAdapter extends TypeAdapter<Kiadasok> {
  @override
  final int typeId = 1;

  @override
  Kiadasok read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Kiadasok(
      date: fields[0] as String,
      place: fields[1] as String,
      price: fields[2] as String,
      kivel: fields[3] as String,
      image_path: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Kiadasok obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.place)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.kivel)
      ..writeByte(4)
      ..write(obj.image_path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KiadasokAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
