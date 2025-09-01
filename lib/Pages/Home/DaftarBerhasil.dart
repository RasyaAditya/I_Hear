import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Home/HomePage.dart';

class Daftarberhasil extends StatefulWidget {
  const Daftarberhasil({super.key});

  @override
  State<Daftarberhasil> createState() => _DaftarBerhasilPageState();
}

class _DaftarBerhasilPageState extends State<Daftarberhasil> {
  @override
  void initState() {
    super.initState();
    // Setelah 2 detik, pindah ke HomePage
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.17, // 20% dari tinggi layar
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Icon/logoNew.png"),
                ),
              ),
            ),
            Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.4, // 40% dari tinggi layar
              // margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/daftarBerhasil.png"),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              "Kamu sudah  Masuk",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "Akun IHEAR Kamu telah berhasil dibuat.",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
