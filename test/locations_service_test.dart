import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_crud/Services/locations_service.dart';

void main(){

  test('location', () async{

    var result = await LocationService().find('Cegléd', '27', 'Mező');
    expect(result.latitude.toDouble(),closeTo(47.1810072, 0.000000001));
    expect(result.longitude.toDouble(),closeTo(19.7938838, 0.000000001));

  });

  test('placeID', () async{

    var result = await LocationService().getPlaceId('Cegléd', '27', 'Mező');
    expect(result,139718153);

  });




}