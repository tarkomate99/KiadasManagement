import 'package:hive_crud/Models/place_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesServices{

  final key = 'AIzaSyBfVaIPJaQrspHslt7Y48c5FehmhhIkxQA';


  Future<List<PlaceSerach>> getAutocomplete(String search) async{
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSerach.fromJson((place))).toList();
  }

}