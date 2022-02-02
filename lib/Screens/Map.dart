import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_crud/Blocs/application_block.dart';
import 'package:hive_crud/Blocs/text_provider.dart';
import 'package:hive_crud/Services/locations_service.dart';
import 'package:hive_crud/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Google_Map extends StatefulWidget {
  const Google_Map({Key? key}) : super(key: key);

  @override
  _Google_MapState createState() => _Google_MapState();
}

class _Google_MapState extends State<Google_Map> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng place;

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  TextEditingController _searchController = TextEditingController();

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(46.253, 20.14824),
    zoom: 11.5,
  );

  @override
  void initState() {
    super.initState();
    _setMarker(LatLng(46.253, 20.14824));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId('marker'), position: point),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<Applicationbloc>(context);
    final text_provider = Provider.of<TextProvider>(context);

    return new Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Google Maps'),
        ),
      ),
      body: Column(
        children: [
          Row(children: [
            Expanded(
                child: TextFormField(
              controller: _searchController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  hintText: '${AppLocalizations.of(context)!.search}'),
            )),
            IconButton(
                onPressed: () async {
                  var text = _searchController.text;
                  // print(text.split(',')[0]);
                  String city = text.split(' ')[0];
                  String street = text.split(' ')[1];
                  String hnumber = text.split(' ')[2];
                  print("City: $city, Street: $street, Number: $hnumber");
                  _goToPLace(city, street, hnumber);
                  text_provider.getText(_searchController.text);
                },
                icon: Icon(Icons.search)),
          ]),
          (applicationBloc.currentLocation == null)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(applicationBloc.currentLocation.latitude,
                            applicationBloc.currentLocation.longitude),
                        zoom: 14),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: _markers,
                  ),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
          text_provider.setText();
        },
        label: Text(''),
        icon: Icon(Icons.beenhere_rounded),
      ),
    );
  }

  Future<void> _goToPLace(String city, String street, String hnumber) async {
    final String url =
        'https://nominatim.openstreetmap.org/search?format=json&counrty=Hungary&city=$city&street=$hnumber $street';

    var response = await http.get(Uri.parse(url));

    var data = convert.jsonDecode(response.body);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(
              double.parse(data[0]['lat']), double.parse(data[0]['lon'])),
          zoom: 20),
    ));
    _setMarker(
        LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon'])));
  }
}
