import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_crud/Models/place_search.dart';
import 'package:hive_crud/Screens/Map.dart';
import 'package:hive_crud/Services/geolocator_service.dart';
import 'package:hive_crud/Services/places_service.dart';

class Applicationbloc with ChangeNotifier{

  final geoLocatorService = GeoLocatorService();
  final placesService = PlacesServices();

  late Position currentLocation;
  late List<PlaceSerach> searchResults;

  Applicationbloc(){
    setCurrentLocation();
  }


  setCurrentLocation() async {

    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }

  serachPLaces(String searchTerm) async{
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}