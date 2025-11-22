// DetailPosisi.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' as math;

import 'package:i_hear/Pages/Home/CekPosisi.dart';
import 'package:i_hear/Pages/Home/CekTujuan.dart';
import 'package:i_hear/Pages/Home/halte&stasiun.dart';

class DetailPosisiPage extends StatefulWidget {
  final Map<String, dynamic>? destination;

  const DetailPosisiPage({super.key, this.destination});

  @override
  State<DetailPosisiPage> createState() => _DetailPosisiPageState();
}

class _DetailPosisiPageState extends State<DetailPosisiPage> {
  // GANTI DENGAN API KEY ANDA YANG VALID
  static const String _apiKey = "AIzaSyALgkBOE7JFF9Dm2PJNGZWBGNsljt50dQk";

  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  String _currentAddress = "Sedang mencari alamat...";
  bool _isSheetExpanded = false;
  StreamSubscription<Position>? _positionStream;

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  String _routeInfo = "";

  // State untuk loading rute
  bool _isFetchingRoute = false;

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-6.1753924, 106.8271528),
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();
    _setupLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _setupLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Lokasi", "Izin lokasi ditolak");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Lokasi", "Izin lokasi permanen ditolak");
      return;
    }

    Position? lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      _updatePositionAndGetAddress(lastPosition);
      _moveCamera(lastPosition);

      // Panggil _getRouteToDestination() langsung di sini
      if (widget.destination != null) {
        _getRouteToDestination(lastPosition);
      }
    }

    // Stream sekarang hanya untuk update posisi saat bergerak
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position pos) {
          _updatePositionAndGetAddress(pos);
        });
  }

  void _updatePositionAndGetAddress(Position position) {
    setState(() {
      _currentPosition = position;
    });
    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      if (mounted) {
        // Cek jika widget masih ada di tree
        setState(() {
          _currentAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}";
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  Future<void> _moveCamera(Position position) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17.0,
        ),
      ),
    );
  }

  Future<void> _getRouteToDestination(Position startPosition) async {
    if (widget.destination == null) return;

    setState(() => _isFetchingRoute = true); // Mulai loading

    final LatLng origin = LatLng(
      startPosition.latitude,
      startPosition.longitude,
    );
    final LatLng destination = LatLng(
      widget.destination!['lat'],
      widget.destination!['lng'],
    );

    _addDestinationMarker(destination, widget.destination!['name']);

    PolylinePoints polylinePoints = PolylinePoints(apiKey: _apiKey);
    List<LatLng> polylineCoordinates = [];

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.transit,
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        if (mounted) {
          setState(() {
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                color: Colors.red,
                width: 5,
              ),
            );
            _routeInfo = "Rute ditampilkan";
          });
        }
        _moveCameraToShowRoute(origin, destination);
      } else {
        Get.snackbar("Error", result.errorMessage ?? "Gagal mendapatkan rute");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      if (mounted) {
        setState(() => _isFetchingRoute = false); // Selesai loading
      }
    }
  }

  void _addDestinationMarker(LatLng position, String title) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: position,
          infoWindow: InfoWindow(title: title),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  Future<void> _moveCameraToShowRoute(LatLng origin, LatLng destination) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;

    double south = math.min(origin.latitude, destination.latitude);
    double west = math.min(origin.longitude, destination.longitude);
    double north = math.max(origin.latitude, destination.latitude);
    double east = math.max(origin.longitude, destination.longitude);

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  Set<Circle> _createCircles() {
    if (_currentPosition == null) return <Circle>{};
    return {
      Circle(
        circleId: const CircleId("fill"),
        center: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        radius: 12,
        strokeWidth: 2,
        strokeColor: Colors.white,
        fillColor: const Color(0xff2F80ED),
      ),
    };
  }

  Widget _buildRouteDetailSheet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Icon(
          _isSheetExpanded
              ? Icons.keyboard_arrow_down_sharp
              : Icons.keyboard_arrow_up_sharp,
          color: Colors.grey,
          size: 50,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rute ke Tujuan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.my_location, color: Color(0xff2F80ED)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _currentAddress,
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: SizedBox(height: 8, child: VerticalDivider()),
              ),
              Row(
                children: [
                  const Icon(Icons.flag, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.destination?['name'] ?? 'Tujuan',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _routeInfo.isEmpty ? "Menghitung rute..." : _routeInfo,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultOptionsSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Icon(
          _isSheetExpanded
              ? Icons.keyboard_arrow_down_sharp
              : Icons.keyboard_arrow_up_sharp,
          color: Colors.grey,
          size: 50,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.04,
            0,
            screenWidth * 0.04,
            screenWidth * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Posisi Kamu di Sini!',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Center(
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Color(0xff2F80ED),
                      size: 16,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        _currentAddress,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: Expanded(
                        child: Text(
                          "Tingkat Keamanan Lokasi:",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 0, 253, 93),
                      size: 16,
                    ),
                    Text(
                      " Aman",
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.06 ),
              _buildOptionButton(
                icon: Image.asset("assets/Icon/map.png", height: 30),
                title: 'Kamu mau kemana?',
                subtitle: 'ketuk untuk mencari rute',
                onTap: () {
                  Get.to(() => const CariTujuanPage());
                },
                context: context,
              ),
              SizedBox(height: screenHeight * 0.015),
              _buildOptionButton(
                icon: const Icon(
                  Icons.directions_bus,
                  color: Color(0xff2F80ED),
                  size: 30,
                ),
                title: 'Halte & Stasiun',
                subtitle: 'temukan halte & stasiun terdekat',
                onTap: () {
                  if (_currentPosition != null) {
                    Get.to(
                      () => HalteStasiunPage(currentPosition: _currentPosition),
                    );
                  } else {
                    Get.snackbar(
                      "Lokasi",
                      "Tunggu sebentar, posisi belum terbaca",
                    );
                  }
                },
                context: context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Posisi Kamu",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4AC2FF), Color(0xff2F80ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            circles: _createCircles(),
            polylines: _polylines,
            markers: _markers,
          ),

          if (!_isFetchingRoute)
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                final isExpanded =
                    notification.extent > notification.initialExtent + 0.05;
                if (isExpanded != _isSheetExpanded) {
                  setState(() => _isSheetExpanded = isExpanded);
                }
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.3,
                maxChildSize: 0.6,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0),
                          ),
                          boxShadow: [
                            BoxShadow(blurRadius: 10.0, color: Colors.black26),
                          ],
                        ),
                        child: ListView(
                          controller: scrollController,
                          children: [
                            widget.destination != null
                                ? _buildRouteDetailSheet(context)
                                : _buildDefaultOptionsSheet(context),
                          ],
                        ),
                      );
                    },
              ),
            ),

          // Overlay loading saat rute sedang dicari
          if (_isFetchingRoute)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      'Mencari rute terbaik...',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_currentPosition == null && !_isFetchingRoute)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_currentPosition != null) {
            if (widget.destination != null) {
              _moveCameraToShowRoute(
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                LatLng(widget.destination!['lat'], widget.destination!['lng']),
              );
            } else {
              await _moveCamera(_currentPosition!);
            }
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(
          widget.destination != null ? Icons.route : Icons.my_location,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required Widget icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
