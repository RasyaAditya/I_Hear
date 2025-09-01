import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_hear/Pages/Auth/DaftarPage.dart';
import 'package:i_hear/Pages/Auth/MasukPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool afterHover = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Container(
                  height: constraints.maxHeight * 0.15, // 20% dari tinggi layar
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Icon/logoNew.png"),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Container(
                  height: constraints.maxHeight * 0.37, // 40% dari tinggi layar
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logingmbr.png"),
                    ),
                  ),
                ),
                Spacer(), // untuk mendorong tombol ke bawah
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.16,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.060,
                    width: double.infinity,
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          afterHover = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          afterHover =
                              false; // kalau mau balik lagi saat keluar hover
                        });
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(MasukPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: afterHover
                              ? Colors.white
                              : const Color(0xFF2F80ED),
                          foregroundColor: afterHover
                              ? const Color(0xFF2F80ED)
                              : Colors.white,
                          side: afterHover
                              ? const BorderSide(
                                  color: Color(0xFF2F80ED),
                                  width: 2,
                                )
                              : BorderSide.none,
                        ),
                        child: Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: afterHover
                                ? const Color(0xFF2F80ED)
                                : Colors.white, // teks ikut ganti warna
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.16,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.060,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(Daftarpage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2F80ED),
                      ),
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            );
          },
        ),
      ),
    );
  }
}
