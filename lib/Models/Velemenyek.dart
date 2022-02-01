import 'package:hive/hive.dart';

part 'Velemenyek.g.dart';

@HiveType(typeId: 2, adapterName: "VelemenyekAdapter")
class Velemenyek {
  @HiveField(0)
  String velemeny;

  Velemenyek({required this.velemeny});
}
