import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithSearch extends StatefulWidget {
  const MapWithSearch({super.key});

  @override
  State<MapWithSearch> createState() => _MapWithSearchState();
}

class _MapWithSearchState extends State<MapWithSearch> {
  late GoogleMapController mapController;

  final LatLng _initialPosition = const LatLng(
    -6.1352,
    106.8133,
  ); // Jakarta Kota

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map full screen
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),

          // Floating TextField
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Cari Stasiun atau Lokasi",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                ),
                onSubmitted: (value) {
                  debugPrint("Cari: $value");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
