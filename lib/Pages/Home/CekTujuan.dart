import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// Model untuk mengambil nama utama lokasi saja
class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({required this.description, required this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['structured_formatting']['main_text'] as String,
      placeId: json['place_id'] as String,
    );
  }
}

// Model untuk menyimpan detail langkah rute yang sudah terstruktur
class RouteStep {
  final String vehicle;
  final String lineName;
  final String from;
  final String to;
  final String duration;
  final int stopCount;

  RouteStep({
    required this.vehicle,
    required this.lineName,
    required this.from,
    required this.to,
    required this.duration,
    required this.stopCount,
  });
}

class CariTujuanPage extends StatefulWidget {
  const CariTujuanPage({super.key});

  @override
  State<CariTujuanPage> createState() => _CariTujuanPageState();
}

class _CariTujuanPageState extends State<CariTujuanPage> {
  // GANTI DENGAN API KEY ANDA YANG VALID
  static const String _apiKey =
      "AIzaSyALgkBOE7JFF9Dm2PJNGZWBGNsljt50dQk"; // PERHATIAN: Ganti dengan API Key Anda

  String _transportasiValue = "bus"; // 'bus' atau 'train'
  String _transportasiDisplay = "Pilih Transportasi";

  final TextEditingController _dariController = TextEditingController();
  final TextEditingController _keController = TextEditingController();

  String? _originPlaceId;
  String? _destPlaceId;

  List<RouteStep> _hasilRute = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _searchAttempted = false;

  @override
  void initState() {
    super.initState();
    _updateTransportDisplay(_transportasiValue);
  }

  void _updateTransportDisplay(String value) {
    if (value == 'bus') {
      _transportasiDisplay = 'Bus / Transjakarta';
    } else if (value == 'train') {
      _transportasiDisplay = 'Kereta / KRL / MRT';
    }
  }

  Future<List<PlacePrediction>> _getSuggestions(String input) async {
    if (input.isEmpty) return [];

    // Filter pencarian berdasarkan moda transportasi yang dipilih
    String searchInput;
    if (_transportasiValue == 'bus') {
      searchInput = '$input halte transjakarta';
    } else {
      searchInput = '$input stasiun';
    }

    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': searchInput,
        'types': 'transit_station',
        'components': 'country:id',
        'location': '-6.2088,106.8456', // Prioritaskan area Jakarta
        'radius': '50000', // Radius 50km
        'key': _apiKey,
      },
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "OK" && data["predictions"] != null) {
          final List predictions = data["predictions"];
          return predictions.map((p) => PlacePrediction.fromJson(p)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching suggestions: $e");
    }
    return [];
  }

  Future<Map<String, double>?> _getLatLngFromPlaceId(String placeId) async {
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {'place_id': placeId, 'fields': 'geometry', 'key': _apiKey},
    );
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      final location = data["result"]["geometry"]["location"];
      return {"lat": location["lat"], "lng": location["lng"]};
    } catch (e) {
      debugPrint("Error fetching place details: $e");
      return null;
    }
  }

  Future<void> _cariRute() async {
    if (_originPlaceId == null || _destPlaceId == null) return;

    setState(() {
      _isLoading = true;
      _searchAttempted = true;
      _errorMessage = '';
      _hasilRute.clear();
    });

    final origin = await _getLatLngFromPlaceId(_originPlaceId!);
    final dest = await _getLatLngFromPlaceId(_destPlaceId!);

    if (origin == null || dest == null) {
      setState(() {
        _errorMessage = "Gagal mendapatkan detail lokasi.";
        _isLoading = false;
      });
      return;
    }

    // --- PERUBAHAN DI SINI: MENAMBAHKAN transit_mode ---
    final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${origin["lat"]},${origin["lng"]}',
      'destination': '${dest["lat"]},${dest["lng"]}',
      'mode': 'transit',
      'transit_mode': _transportasiValue, // 'bus' atau 'train'
      'departure_time': 'now',
      'key': _apiKey,
    });

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data["status"] == "OK" && data["routes"].isNotEmpty) {
        List<RouteStep> steps = [];
        for (var step in data["routes"][0]["legs"][0]["steps"]) {
          if (step["travel_mode"] == "TRANSIT") {
            final transit = step["transit_details"];
            final vehicleType = transit["line"]["vehicle"]["type"]
                .toString()
                .toLowerCase();

            // --- FILTER KETAT BERDASARKAN JENIS KENDARAAN ---
            bool isBusRoute = vehicleType.contains('bus');
            bool isTrainRoute =
                vehicleType.contains('rail') ||
                vehicleType.contains('subway') ||
                vehicleType.contains('train');

            if ((_transportasiValue == 'bus' && isBusRoute) ||
                (_transportasiValue == 'train' && isTrainRoute)) {
              steps.add(
                RouteStep(
                  vehicle: transit["line"]["vehicle"]["name"],
                  lineName:
                      transit["line"]["short_name"] ?? transit["line"]["name"],
                  from: transit["departure_stop"]["name"],
                  to: transit["arrival_stop"]["name"],
                  duration: step["duration"]["text"],
                  stopCount: transit["num_stops"],
                ),
              );
            }
          }
        }
        if (steps.isEmpty) {
          _errorMessage =
              "Tidak ada rute ${_transportasiValue == 'bus' ? 'bus' : 'kereta'} langsung yang ditemukan.";
        }
        setState(() => _hasilRute = steps);
      } else {
        setState(
          () => _errorMessage =
              "Gagal mengambil rute: ${data["error_message"] ?? data["status"]}",
        );
      }
    } catch (e) {
      setState(() => _errorMessage = "Terjadi kesalahan: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PERUBAHAN DI SINI: Menentukan ikon berdasarkan state ---
    final IconData selectedIcon = _transportasiValue == 'bus'
        ? Icons.directions_bus
        : Icons.train;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tujuan Kamu",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff4AC2FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ## KOTAK 1: PILIH TRANSPORTASI ##
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: _buildTransportSelector(),
          ),

          // ## KOTAK 2: TITIK AWAL & TUJUAN ##
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildAutocompleteRow(
                  controller: _dariController,
                  hint: "Tentukan titik awal",
                  icon: selectedIcon, // Menggunakan ikon dinamis
                  onSelected: (prediction) {
                    setState(() {
                      _dariController.text = prediction.description;
                      _originPlaceId = prediction.placeId;
                    });
                    if (_destPlaceId != null) _cariRute();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[200],
                  ),
                ),
                _buildAutocompleteRow(
                  controller: _keController,
                  hint: "Cari tujuan Kamu",
                  icon: selectedIcon, // Menggunakan ikon dinamis
                  onSelected: (prediction) {
                    setState(() {
                      _keController.text = prediction.description;
                      _destPlaceId = prediction.placeId;
                    });
                    if (_originPlaceId != null) _cariRute();
                  },
                ),
              ],
            ),
          ),

          // ## HASIL RUTE ##
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildResultsView(),
          ),
        ],
      ),
    );
  }

  // Widget baru untuk menampilkan hasil, error, atau state kosong
  Widget _buildResultsView() {
    if (_errorMessage.isNotEmpty) {
      return _buildEmptyState(
        icon: Icons.error_outline,
        message: _errorMessage,
      );
    }
    if (_hasilRute.isEmpty) {
      return _buildEmptyState(
        icon: Icons.route_outlined,
        message: _searchAttempted
            ? "Rute tidak ditemukan."
            : "Pilih titik awal dan tujuan untuk melihat rute.",
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _hasilRute.length,
      itemBuilder: (context, index) {
        final step = _hasilRute[index];
        return _buildRouteStepCard(step, index + 1);
      },
    );
  }

  // Widget untuk menampilkan kartu hasil rute (UI baru)
  Widget _buildRouteStepCard(RouteStep step, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xff4AC2FF),
              foregroundColor: Colors.white,
              child: Text(
                index.toString(),
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${step.vehicle} ${step.lineName}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRouteDetailRow(Icons.start, "Dari", step.from),
                  const SizedBox(height: 4),
                  _buildRouteDetailRow(Icons.flag, "Tujuan", step.to),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Icon(Icons.timelapse, color: Colors.grey[600], size: 20),
                const SizedBox(height: 2),
                Text(
                  step.duration,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${step.stopCount} stops',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk tampilan kosong atau error (UI baru)
  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,  
              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportSelector() {
    return InkWell(
      onTap: _showTransportSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          children: [
            Icon(
              _transportasiValue == 'bus' ? Icons.directions_bus : Icons.train,
              color: const Color(0xff2F80ED),
            ),
            const SizedBox(width: 12),
            Text(
              _transportasiDisplay,
              style: GoogleFonts.poppins(color: Colors.black87, fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showTransportSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pilih Moda Transportasi',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.directions_bus,
                  color: Color(0xff2F80ED),
                ),
                title: Text('Bus / Transjakarta', style: GoogleFonts.poppins()),
                onTap: () {
                  _onTransportChanged('bus');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.train, color: Color(0xff2F80ED)),
                title: Text('Kereta / KRL / MRT', style: GoogleFonts.poppins()),
                onTap: () {
                  _onTransportChanged('train');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Fungsi baru untuk mereset state saat ganti transportasi
  void _onTransportChanged(String newValue) {
    if (_transportasiValue == newValue) return;
    setState(() {
      _transportasiValue = newValue;
      _updateTransportDisplay(newValue);
      _dariController.clear();
      _keController.clear();
      _originPlaceId = null;
      _destPlaceId = null;
      _hasilRute.clear();
      _errorMessage = '';
      _searchAttempted = false;
    });
  }

  Widget _buildAutocompleteRow({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ValueChanged<PlacePrediction> onSelected,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff2F80ED)),
        const SizedBox(width: 12),
        Expanded(
          child: Autocomplete<PlacePrediction>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<PlacePrediction>.empty();
              }
              return _getSuggestions(textEditingValue.text);
            },
            displayStringForOption: (PlacePrediction option) =>
                option.description,
            onSelected: onSelected,
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
                  // Sinkronisasi controller internal Autocomplete dengan controller state
                  if (controller.text != textEditingController.text) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      textEditingController.text = controller.text;
                    });
                  }
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width -
                        64, // Sesuaikan dengan padding
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final PlacePrediction option = options.elementAt(index);
                        return ListTile(
                          title: Text(
                            option.description,
                            style: GoogleFonts.poppins(),
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
