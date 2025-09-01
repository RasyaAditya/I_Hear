import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Home/DetailKereta.dart';
import 'package:i_hear/Pages/Home/PosisiKamu.dart';

class CekPosisi extends StatelessWidget {
  const CekPosisi({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 196, 218, 237), // biru
            Colors.white,
          ],
          stops: [0.1, 1.0],
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04,
                  left: MediaQuery.of(context).size.width * 0.06,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.06,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: IconButton(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02,
                            ),
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/Icon/NotifIcon.png",
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Image.asset(
                "assets/Icon/botPosisi.png",
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(DetailPosisiKeretaPage());
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/Icon/trainAwal.png"),
                                color: Color(0xff2F80ED),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stasiun",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.03,
                                      color: Color(0xff878787),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "JAKARTAKOTA",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(height: screenHeight * 0.04),
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/Icon/trainTujuan.png"),
                                color: Color(0xff2F80ED),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stasiun",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.03,
                                      color: Color(0xff878787),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "BOGOR",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: InkWell(
                  onTap: () {
                    // Get.to(MapWithSearch());
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageIcon(
                          AssetImage("assets/Icon/map.png"),
                          color: Color(0xff2F80ED),
                          size: screenHeight * 0.05,
                        ),
                        Text(
                          "Cek Posisi Kamu",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Informasi posisi kamu saat ini.",
                          style: GoogleFonts.poppins(
                            color: Color(0xff878787),
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
