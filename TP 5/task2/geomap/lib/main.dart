import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';



void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Marker> myMarkers = [];

  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationDataTemp;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationDataTemp = await location.getLocation();
    setState(() {
      _locationData = _locationDataTemp;
      myMarkers.add(Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        builder: (ctx) => Container(
          child: Container(
            child: Icon(
              Icons.location_on,
              color: Colors.blueAccent,
              size: 40,
            ),
          ),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("openstreetmap Flutter"),
      ),
      body: Container(
        child: FlutterMap(
          options: MapOptions(
              center: _locationData == null
                  ? LatLng(-20.2410, 57.4732)
                  : LatLng(_locationData!.latitude!, _locationData!.longitude!),
              zoom: 8.0),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(-20.04664,  57.52878),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: ctx,
                        builder: (BuildContext context) {
                          return Container(
                            height: 100,
                            child: Center(
                              child: Text('Hotel 1 : Veranda Pointe Aux Biches'),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(-20.00214, 57.65979),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: ctx,
                        builder: (BuildContext context) {
                          return Container(
                            height: 100,
                            child: Center(
                              child: Text('Hotel 2 : Lux Grand Gaube'),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(-20.0707, 57.5162),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: ctx,
                        builder: (BuildContext context) {
                          return Container(
                            height: 100,
                            child: Center(
                              child: Text('Hotel 3 : Le Meridien'),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(-20.28484, 57.36444),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: ctx,
                        builder: (BuildContext context) {
                          return Container(
                            height: 100,
                            child: Center(
                              child: Text('Hotel 4 : Manisa Hotel Flic En Flac'),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(-20.20582, 57.77744),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: ctx,
                        builder: (BuildContext context) {
                          return Container(
                            height: 100,
                            child: Center(
                              child: Text('Hotel 5 : The Residence Hotel'),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                // Add more markers here with their own info windows
              ],
            ),


          ],
        ),
      ),
    );
  }
}
