import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Siapkan 6 controller dan 6 focus node
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.isEmpty && i > 0) {
          FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Fungsi untuk membuat satu kotak OTP, sekarang menerima screenWidth
  Widget _buildOtpBox(int index, double screenWidth) {
    return SizedBox(
      // Ukuran kotak responsif terhadap lebar layar
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: GoogleFonts.poppins(
          // Ukuran font responsif
          fontSize: screenWidth * 0.055,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero, // Hapus padding internal
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              screenWidth * 0.03,
            ), // Border radius responsif
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar sekali di awal method build
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Padding horizontal responsif
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  Text(
                    "Verifikasi Akun Anda",
                    style: GoogleFonts.poppins(
                      // Ukuran font responsif
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2F80ED),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  Text(
                    "Mohon untuk tidak memberikan kode verifikasi\nAnda kepada orang lain",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      // Ukuran font responsif
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  Image.asset(
                    "assets/images/otp_illustration.png",
                    // Tinggi gambar responsif
                    height: screenHeight * 0.18,
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => _buildOtpBox(index, screenWidth),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tidak menerima kode? ",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Kirim ulang kode OTP");
                        },
                        child: Text(
                          "Kirim Ulang Kode",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF2F80ED),
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  SizedBox(
                    width: double.infinity,
                    // Tinggi tombol responsif
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        String otp = _controllers.map((c) => c.text).join();
                        print("OTP yang dimasukkan: $otp");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F80ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                      ),
                      child: Text(
                        "Verifikasi",
                        style: GoogleFonts.poppins(
                          // Ukuran font responsif
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
