import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;

class LocationService{
  final String key = 'AIzaSyBfVaIPJaQrspHslt7Y48c5FehmhhIkxQA';


  Future<String> getPlaceId(String input) async{
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    print(placeId);

    return placeId;

  }
  Future<Map<String, dynamic>> getPlace(String city, String hnumber, String street) async{

    final String url = 'https://nominatim.openstreetmap.org/search?format=json&counrty=Hungary&city=Cegled&street=27 Mezo';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }
  
  Future<LatLng> find(String city, String hnumber, String street) async {
    final String url = 'https://nominatim.openstreetmap.org/search?format=json&counrty=Hungary&city=$city&street=$hnumber $street';

    var response = await http.get(Uri.parse(url));

    var data = convert.jsonDecode(response.body);
      if(data.length>0){
        return LatLng(
          double.parse(data[0]['lat']),double.parse(data[0]['lon']));
      }
      return LatLng(46.2587, 20.14222);
    }
}
