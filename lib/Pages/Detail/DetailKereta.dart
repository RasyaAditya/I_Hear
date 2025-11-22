import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPosisiKeretaPage extends StatefulWidget {
  const DetailPosisiKeretaPage({super.key});

  @override
  State<DetailPosisiKeretaPage> createState() => _DetailPosisiKeretaPageState();
}

class _DetailPosisiKeretaPageState extends State<DetailPosisiKeretaPage> {
  final List<Map<String, String>> schedule = const [
    {'station': 'JAKARTAKOTA', 'time': '05:21'},
    {'station': 'JAYAKARTA', 'time': '05:25'},
    {'station': 'MANGGA BESAR', 'time': '05:27'},
    {'station': 'SAWAH BESAR', 'time': '05:28'},
    {'station': 'JUANDA', 'time': '05:29'},
    {'station': 'GONDANGDIA', 'time': '05:34'},
    {'station': 'CIKINI', 'time': '05:35'},
    {'station': 'MANGGARAI', 'time': '05:43'},
    {'station': 'TEBET', 'time': '05:47'},
    {'station': 'CAWANG', 'time': '05:50'},
    {'station': 'DUREN KALIBATA', 'time': '05:53'},
    {'station': 'PASAR MINGGU BARU', 'time': '05:55'},
    {'station': 'PASAR MINGGU', 'time': '05:58'},
    {'station': 'TANJUNG BARAT', 'time': '06:02'},
    {'station': 'LENTENG AGUNG', 'time': '06:05'},
    {'station': 'UNIV. PANCASILA', 'time': '06:07'},
    {'station': 'UNIV. INDONESIA', 'time': '06:09'},
    {'station': 'PONDOK CINA', 'time': '06:11'},
    {'station': 'DEPOK BARU', 'time': '06:14'},
    {'station': 'DEPOK', 'time': '06:17'},
    {'station': 'CITAYAM', 'time': '06:23'},
    {'station': 'BOJONG GEDE', 'time': '06:28'},
    {'station': 'CILEBUT', 'time': '06:32'},
    {'station': 'BOGOR', 'time': '06:37'},
  ];

  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // --- URUTAN DIUBAH ---

          // Layer 1: Latar belakang abu-abu (paling bawah)
          Container(color: const Color(0xFFF5F5F5)),

          // Layer 2: ListView SEKARANG di bawah header
          // Ini adalah konten yang akan kita scroll
          ListView.builder(
            padding: EdgeInsets.only(
              // Padding atas harus cukup untuk memberi ruang bagi header dan kartu
              top: screenHeight * 0.32,
              bottom: screenHeight * 0.05,
            ),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final item = schedule[index];
              return _buildTimelineTile(
                stationName: item['station']!,
                time: item['time']!,
                isActive: index == _activeIndex,
                isFirst: index == 0,
                isLast: index == schedule.length - 1,
                onTap: () {
                  setState(() {
                    _activeIndex = index;
                  });
                },
              );
            },
          ),

          // Layer 3: Header Biru (sekarang DI ATAS ListView)
          // Widget ini akan menutupi ListView saat scroll
          Container(
            height: screenHeight * 0.23, // Tinggi disesuaikan dengan kebutuhan
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4AC2FF), Color(0xff2F80ED)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),

          // Layer 4 & 5: AppBar dan Kartu Putih (paling atas)
          _buildCustomAppBar(context),
          _buildOverlappingCard(context),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // --- PERUBAHAN 3: Menambahkan Padding untuk menurunkan posisi title ---
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Detail Posisi Kereta',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset("assets/Icon/NotifIcon.png", height: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOverlappingCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top:
          screenHeight *
          0.14, // Sedikit diturunkan agar center dengan appbar baru
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStationRow(
              context,
              'Stasiun',
              'JAKARTAKOTA',
              ImageIcon(
                AssetImage("assets/Icon/trainAwal.png"),
                color: Color(0xff2F80ED),
              ),
            ),
            const Divider(height: 16),
            _buildStationRow(
              context,
              'Stasiun',
              'BOGOR',
              ImageIcon(
                AssetImage("assets/Icon/trainTujuan.png"),
                color: Color(0xff2F80ED),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets (_buildStationRow, _buildTimelineTile, dll) tetap sama
  // ... (Sisa kode helper tidak perlu diubah) ...
  Widget _buildStationRow(
    BuildContext context,
    String label,
    String station,
    Widget icon,
  ) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            Text(
              station,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineTile({
    required String stationName,
    required String time,
    required VoidCallback onTap,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 70,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isFirst
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? const Color(0xff2F80ED) : Colors.white,
                      border: Border.all(
                        color: isActive
                            ? const Color(0xff2F80ED)
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isLast ? Colors.transparent : Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                  right: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildStationButton(stationName, isActive, onTap),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _buildTimeButton(time, isActive, onTap),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationButton(String name, bool isActive, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: isActive ? 2 : 0,
        backgroundColor: isActive ? const Color(0xff2F80ED) : Colors.white,
        foregroundColor: isActive ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isActive ? Colors.transparent : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        name,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  Widget _buildTimeButton(String time, bool isActive, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive ? const Color(0xff2F80ED) : Colors.white,
        foregroundColor: isActive ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(
          color: isActive ? Colors.transparent : Colors.grey.shade400,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        time,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }
}
