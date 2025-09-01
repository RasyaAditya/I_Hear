import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Home/HomePage.dart';

class LoginSuccessPage extends StatefulWidget {
  const LoginSuccessPage({super.key});

  @override
  State<LoginSuccessPage> createState() => _LoginSuccessPageState();
}

class _LoginSuccessPageState extends State<LoginSuccessPage> {
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
                  image: AssetImage("assets/images/loginBerhasil.png"),
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
              "Selamat datang kembali di Akun IHEAR",
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
