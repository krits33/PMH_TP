import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapSimplePage extends StatefulWidget {
  const MapSimplePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MapSimplePage> createState() => _MapSimplePageState();
}

class _MapSimplePageState extends State<MapSimplePage> {
  static const LatLng initialPosition = const LatLng(-20.2975, 57.72556);
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: initialPosition,
    zoom: 15,
  );

  late BitmapDescriptor markerIcon;
  final Completer<GoogleMapController> controllerMap = Completer();
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  LatLng? destination;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    addCustomIcon();
  }

  void addCustomIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/location.png",
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      markers.add(
        Marker(
          markerId: const MarkerId("id-1"),
          position: initialPosition,
          icon: markerIcon,
          infoWindow: const InfoWindow(title: "Olivia"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            markers: markers,
            polylines: polylines,
            onTap: _onMapTapped,
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _buildMapControls(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    );
  }

  Widget _buildMapControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            _getDirections();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
          ),
          child: Text(
            "Get Directions",
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _getTimeToReach();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
          ),
          child: Text(
            "Time to Reach",
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _selectDestination();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
          ),
          child: Text(
            "Select Destination",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      destination = tappedPoint;
      markers.removeWhere((marker) => marker.markerId.value == "id-2");
      markers.add(
        Marker(
          markerId: const MarkerId("id-2"),
          position: destination!,
          icon: markerIcon,
          infoWindow: const InfoWindow(title: "Destination"),
        ),
      );

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.purple,
          width: 5,
          points: [initialPosition, destination!],
        ),
      );
    });
  }

  Future<void> _getTimeToReach() async {
    if (destination == null) {
      return;
    }

    final apiKey =
        'AIzaSyC7SFCdXIAYjsIdQ8FV3D186bkChZdJyh8'; // Replace with your API key
    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${destination!.latitude},${destination!.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final routes = data['routes'];
        if (routes != null && routes.isNotEmpty) {
          final legs = routes[0]['legs'];
          if (legs != null && legs.isNotEmpty) {
            final duration = legs[0]['duration'];
            if (duration != null) {
              final durationText = duration['text'];
              print('Time to reach: $durationText');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Time to reach: $durationText'),
                ),
              );
              return;
            }
          }
        }
      }

      // Handle error
      print('Error: Unable to retrieve time to reach');
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  Future<void> _getDirections() async {
    if (destination == null) {
      return;
    }

    final apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key
    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${destination!.latitude},${destination!.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final routes = data['routes'];
        if (routes != null && routes.isNotEmpty) {
          final legs = routes[0]['legs'];
          if (legs != null && legs.isNotEmpty) {
            final duration = legs[0]['duration'];
            if (duration != null) {
              final durationText = duration['text'];
              print('Duration: $durationText');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Estimated time: $durationText'),
                ),
              );
              return;
            }
          }
        }
      }

      // Handle error
      print('Error: Unable to retrieve directions');
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  void _selectDestination() async {
    LatLng? selectedPoint = await showDialog<LatLng>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Destination"),
          content: Text("Tap on the map to select your destination."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );

    if (selectedPoint != null) {
      setState(() {
        destination = selectedPoint;
        markers.removeWhere((marker) => marker.markerId.value == "id-2");
        markers.add(
          Marker(
            markerId: const MarkerId("id-2"),
            position: destination!,
            icon: markerIcon,
            infoWindow: const InfoWindow(title: "Destination"),
          ),
        );

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.purple,
            width: 5,
            points: [initialPosition, destination!],
          ),
        );
      });
    }
  }
}
