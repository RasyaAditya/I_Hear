import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:i_hear/Pages/Detail/DetailPosisi.dart';

class HalteStasiunPage extends StatefulWidget {
  final Position? currentPosition;

  const HalteStasiunPage({super.key, required this.currentPosition});

  @override
  State<HalteStasiunPage> createState() => _HalteStasiunPageState();
}

class _HalteStasiunPageState extends State<HalteStasiunPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = "";
  bool _isLoading = true;
  int _tabIndex = 0;

  List<Map<String, dynamic>> halteList = [];
  List<Map<String, dynamic>> stasiunList = [];
  List<Map<String, dynamic>> globalSearchList = [];

  static const apiKey = "AIzaSyALgkBOE7JFF9Dm2PJNGZWBGNsljt50dQk";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.currentPosition != null) {
      _fetchNearbyStops();
    }
  }

  Future<void> _fetchNearbyStops() async {
    final lat = widget.currentPosition!.latitude;
    final lng = widget.currentPosition!.longitude;

    try {
      // ================== Request Halte (bus station) ==================
      final halteUrl =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
          "?location=$lat,$lng"
          "&radius=5000"
          "&type=bus_station"
          "&key=$apiKey";

      final halteResponse = await http.get(Uri.parse(halteUrl));
      final halteData = json.decode(halteResponse.body);

      final halte = (halteData["results"] as List).map((place) {
        return {
          "name": place["name"],
          "lat": place["geometry"]["location"]["lat"],
          "lng": place["geometry"]["location"]["lng"],
          "type": "bus_station",
        };
      }).toList();

      // ================== Request Stasiun (train station) ==================
      final stasiunUrl =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
          "?location=$lat,$lng"
          "&radius=5000"
          "&type=train_station"
          "&key=$apiKey";

      final stasiunResponse = await http.get(Uri.parse(stasiunUrl));
      final stasiunData = json.decode(stasiunResponse.body);

      final stasiun = (stasiunData["results"] as List).map((place) {
        return {
          "name": place["name"],
          "lat": place["geometry"]["location"]["lat"],
          "lng": place["geometry"]["location"]["lng"],
          "type": "train_station",
        };
      }).toList();

      setState(() {
        halteList = halte.cast<Map<String, dynamic>>();
        stasiunList = stasiun.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching places: $e");
    }
  }

  Future<void> _searchGlobal(String query, String type) async {
    if (query.isEmpty) {
      setState(() => globalSearchList.clear());
      return;
    }

    final lat = widget.currentPosition!.latitude;
    final lng = widget.currentPosition!.longitude;

    try {
      final url =
          "https://maps.googleapis.com/maps/api/place/textsearch/json"
          "?query=$query&type=$type"
          "&location=$lat,$lng"
          "&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      final results = (data["results"] as List).map((place) {
        return {
          "name": place["name"],
          "lat": place["geometry"]["location"]["lat"],
          "lng": place["geometry"]["location"]["lng"],
          "type": type,
        };
      }).toList();

      setState(() {
        globalSearchList = results.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("Error search global: $e");
    }
  }

  double _calculateDistance(double lat, double lng) {
    if (widget.currentPosition == null) return 0.0;
    return Geolocator.distanceBetween(
          widget.currentPosition!.latitude,
          widget.currentPosition!.longitude,
          lat,
          lng,
        ) /
        1000; // km
  }

  Widget _highlightText(String text, String query) {
    if (query.isEmpty) return Text(text);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(text);
    }

    final startIndex = lowerText.indexOf(lowerQuery);
    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>> list,
    String label,
    String type,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Kalau ada global search, pakai globalSearchList
    final dataSource = _searchQuery.isNotEmpty && globalSearchList.isNotEmpty
        ? globalSearchList
        : list;

    final filteredList = dataSource.where((halte) {
      final query = _searchQuery.trim().toLowerCase();
      final name = halte["name"].toString().toLowerCase();
      return name.contains(query);
    }).toList();

    filteredList.sort((a, b) {
      final jarakA = _calculateDistance(a["lat"], a["lng"]);
      final jarakB = _calculateDistance(b["lat"], b["lng"]);
      return jarakA.compareTo(jarakB);
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF5F7FB),
              hintText: "Cari $label...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade300, width: 1),
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
              _searchGlobal(value, type);
            },
          ),
        ),
        Expanded(
          child: filteredList.isEmpty
              ? const Center(child: Text("Tidak ada data ditemukan"))
              : ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final halte = filteredList[index];
                    final jarak = _calculateDistance(
                      halte["lat"],
                      halte["lng"],
                    );
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F7FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          // ---- PERUBAHAN DI SINI ----
                          // Kumpulkan data tujuan dalam sebuah Map
                          final destinationData = {
                            "name": halte["name"],
                            "lat": halte["lat"],
                            "lng": halte["lng"],
                          };
                          // Kirim data ke DetailPosisiPage saat navigasi
                          Get.to(
                            () =>
                                DetailPosisiPage(destination: destinationData),
                          );
                          // -------------------------
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            halte["type"] == "train_station"
                                ? "STASIUN"
                                : "BUS STOP",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        title: _highlightText(halte["name"], _searchQuery),
                        subtitle: Text(
                          "${jarak.toStringAsFixed(2)} km dari posisi Kamu",
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,

        title: Text(
          "  Halte & Stasiun",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Toggle Halte - Stasiun
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _tabIndex = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _tabIndex == 0
                                    ? const Color(0xff2F80ED)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Halte",
                                  style: GoogleFonts.poppins(
                                    color: _tabIndex == 0
                                        ? Colors.white
                                        : Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _tabIndex = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _tabIndex == 1
                                    ? const Color(0xff2F80ED)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Stasiun",
                                  style: GoogleFonts.poppins(
                                    color: _tabIndex == 1
                                        ? Colors.white
                                        : Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // List Content
                Expanded(
                  child: _tabIndex == 0
                      ? _buildList(halteList, "Halte", "bus_station")
                      : _buildList(stasiunList, "Stasiun", "train_station"),
                ),
              ],
            ),
    );
  }
}
