// Import Flutter's material library for building UI components
import 'package:flutter/material.dart';
// Import a custom module or file named 'map_location_details.dart'
import 'package:flutter_geolocation/map_location_details.dart';
import 'package:flutter_geolocation/map_simple.dart';
// Import the 'location' package for handling location services in the app
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});
  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /* 
  serviceEnabled and permissionGranted are used 
  to check if location service is enable and permission is granted 
  */
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;

  // Store the user's location data
  LocationData? userLocation;

  // This function will get user location
  Future<void> getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // Exit the function if service is not enabled
      }
    }

    // Check if permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // Exit the function if permission is not granted
      }
    }

    // Get the user's location data
    final locationData = await location.getLocation();
    setState(() {
      userLocation = locationData;
    });
  }

  // Function to navigate to the Geocoding page
  goToGeolocation() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GeocodingPage(
                title: "Geocoding",
              )),
    );
  }

  // Function to navigate to the Simple Map page
  goToSimpleMap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MapSimplePage(
                title: "Live Tracking",
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button to check user's location
              ElevatedButton(
                  onPressed: getUserLocation,
                  child: const Text('Check Location')),
              // Button to navigate to the Geocoding page

              // Button to navigate to the Simle Map page
              ElevatedButton(
                  onPressed: goToSimpleMap, child: const Text('Live Tracker')),
              const SizedBox(height: 25),
              // Display latitude & longtitude
              userLocation != null
                  ? Wrap(
                      children: [
                        // Display user's latitude
                        Center(
                            child: Text(
                                'Your latitude: ${userLocation?.latitude}')),
                        // Display user's longitude
                        Center(
                            child: Text(
                                'Your longitude: ${userLocation?.longitude}')),
                      ],
                    )
                  : const Text(
                      'Please enable location service and grant permission')
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getUserLocation,
        label: const Text('Get Location'),
        icon: const Icon(Icons.location_on),
        backgroundColor: Color.fromARGB(255, 91, 176, 99),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
