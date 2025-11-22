import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Detail/DetailPosisi.dart';
import 'package:i_hear/Pages/Home/CekPosisi.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart'; // untuk bunyi klik

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  String? qrCode;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Animasi garis scanning
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ukuran layar
    final size = MediaQuery.of(context).size;
    final double scanBoxSize = size.width * 0.7; // 70% dari lebar layar

    return Scaffold(
      body: Stack(
        children: [
          // Kamera background
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                setState(() {
                  qrCode = barcode.rawValue;
                });
              }
            },
          ),

          // Overlay UI
          Column(
            children: [
              SizedBox(height: size.height * 0.08),
              Center(
                child: Text(
                  "Scan QR",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Center(
                child: Text(
                  "Pindai Kode QR untuk informasi selanjutnya.",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.035,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.05),

              // Kotak scanner responsif
              Expanded(
                child: Center(
                  child: Stack(
                    children: [
                      // Kotak scanner
                      Container(
                        width: scanBoxSize,
                        height: scanBoxSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      // Garis scanning animasi
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final position =
                              _animationController.value * (scanBoxSize - 4);
                          return Positioned(
                            top: position,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: scanBoxSize,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withAlpha(204),
                                    blurRadius: 8,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol kamera
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.05),
                    child: GestureDetector(
                      onTap: () {
                        // Bunyi klik bawaan sistem
                        SystemSound.play(SystemSoundType.click);

                        // Navigasi
                        Get.to(const CekPosisi());
                      },
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black87,
                          size: size.width * 0.08,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: size.height * 0.05,
                      left: size.width * 0.05,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Bunyi klik bawaan sistem
                        SystemSound.play(SystemSoundType.click);

                        // Navigasi
                        Get.to(const DetailPosisiPage());
                      },
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.map_sharp,
                          color: Colors.black87,
                          size: size.width * 0.08,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
