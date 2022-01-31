import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'Kiadasok.g.dart';

@HiveType(typeId: 1, adapterName: "KiadasokAdapter")
class Kiadasok{

  @HiveField(0)
  String date;

  @HiveField(1)
  String place;

  @HiveField(2)
  String price;

  @HiveField(3)
  String kivel;

  @HiveField(4)
  String image_path;

  Kiadasok({required this.date, required this.place, required this.price, required this.kivel, required this.image_path});

}