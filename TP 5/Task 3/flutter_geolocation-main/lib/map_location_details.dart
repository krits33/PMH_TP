// ignore_for_file: use_build_context_synchronously

// Import Flutter's foundation library (might not be necessary in typical Flutter code)
import 'package:flutter/foundation.dart';
// Import Flutter's material library for building UI components
import 'package:flutter/material.dart';
// Import the Google Maps Flutter package for integrating Google Maps
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Import the geocoding package for geocoding services (address to coordinates and vice versa)
import 'package:geocoding/geocoding.dart';

class GeocodingPage extends StatefulWidget {
  const GeocodingPage({super.key, required this.title});
  final String title;

  @override
  State<GeocodingPage> createState() => _GeocodingPageState();
}

class _GeocodingPageState extends State<GeocodingPage> {
  GoogleMapController?
      mapController; // Controller for the Google Map: to control the Google Map.
  Set<Marker> markers = {}; // Set to hold map markers
  Marker? selectedMarker; // Store the selected marker
  LatLng? selectedLatLng; // Store the selected LatLng

  // Constant defining the initial camera position for the Google Map
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-20.2479347, 57.5671908), // Initial map center coordinates
    zoom: 11.12, // Initial zoom level for the map
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            // Callback when the map is created
            onMapCreated: (controller) {
              mapController =
                  controller; // Set the map controller when the map is created
            },
            // Callback when the map is tapped at a specific LatLng
            onTap: (LatLng latLng) {
              // Clear previous markers and create a new one at the tapped location
              setState(() {
                markers.clear(); // Clear existing markers
                selectedLatLng = latLng; // Store the newly tapped LatLng
                markers.add(
                  Marker(
                    markerId:
                        const MarkerId('selected_marker'), // Unique marker ID
                    position:
                        latLng, // Position of the marker at the tapped location
                  ),
                );
              });
            },
            markers: markers, // Set of markers to display on the map
            initialCameraPosition:
                _kGooglePlex, // Initial camera position for the map
          ),
          if (selectedLatLng != null)
            Positioned(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected location',
                      style:
                          TextStyle(color: Color.fromARGB(255, 108, 255, 34)),
                    ),
                    Text(
                      'Latitude: ${selectedLatLng!.latitude}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Longitude: ${selectedLatLng!.longitude}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getLatLng,
        label: const Text('Location more info'),
        icon: const Icon(Icons.location_on),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _getLatLng() async {
    // Check if a LatLng has been selected
    if (selectedLatLng != null) {
      try {
        // Use geocoding to get placemarks (address details) for the selected LatLng
        List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLatLng!.latitude,
          selectedLatLng!.longitude,
        );

        if (placemarks.isNotEmpty) {
          // If placemarks are found, display more information using the 'display' function
          Placemark placemark = placemarks.first;
          display(context, placemark);
        } else {
          // If no address is found, show a SnackBar to inform the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No address found for the selected location."),
            ),
          );
        }
      } catch (e) {
        // Handle any errors and print them if in debug mode
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    } else {
      // Show a SnackBar to inform the user to select a location on the map first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a location on the map first."),
        ),
      );
    }
  }

  Future<void> display(BuildContext context, Placemark placemark) async {
    return showDialog(
      context: context, // Display the dialog in the specified context
      builder: (context) {
        return AlertDialog(
          title: const Text('More Info'), // Dialog title
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Display location name or "N/A" if it's null
                Text('Location Name: ${placemark.name ?? "N/A"}'),
                // Display street or "N/A" if it's null
                Text('Street: ${placemark.street ?? "N/A"}'),
                // Display city or "N/A" if it's null
                Text('City: ${placemark.locality ?? "N/A"}'),
                // Display state or "N/A" if it's null
                Text('State: ${placemark.administrativeArea ?? "N/A"}'),
                // Display postal code or "N/A" if it's null
                Text('Postal Code: ${placemark.postalCode ?? "N/A"}'),
                // Display country or "N/A" if it's null
                Text('Country: ${placemark.country ?? "N/A"}'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(
                  context), // Close the dialog when the "OK" button is pressed
              child: const Text('OK'), // Button text
            ),
          ],
        );
      },
    );
  }
}
