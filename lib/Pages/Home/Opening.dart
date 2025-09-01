import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Auth/LoginPage.dart';
import 'package:i_hear/Pages/Home/ChatBot.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/op4.png",
      "bot": "assets/Icon/botbiru.png",
      "title": "Halo, Aku SAPA!",
      "subtitle":
          "I-Hear hadir untuk menjembatani komunikasi antara teman Tuli & Bisu, serta masyarakat umum 👂✨",
    },
    {
      "image": "assets/images/op2.png",
      "title": "Halo, Aku SAPA!",
      "subtitle":
          "Belajar dan gunakan Bahasa Isyarat dengan fitur Isyarat Pintar & Lensa Isyarat yang interaktif 📱🤟",
    },
    {
      "image": "assets/images/op3.png",
      "title": "Tanya Langsung #BarengSAPA",
      "subtitle":
          "Nikmati fitur Voice to Text dan Sapa Bot untuk percakapan sehari-hari lebih mudah 🎤➡📝",
    },
    {
      "image": "assets/images/op1.png",
      "title": "Komunikasi Jadi Lebih Mudah",
      "subtitle":
          "Bersama I-Hear, kita ciptakan ruang komunikasi inklusif yang lebih baik untuk semua 🤝🌍",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Bagian PageView (gambar + teks)
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // Gambar dengan subtitle
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.white,
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Image.asset(
                              pages[index]["image"]!,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.01,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (pages[index]["bot"] != null)
                          Positioned(
                            bottom: 100,
                            left: 20,
                            right: 20,
                            child: Image.asset(
                              pages[index]["bot"]!,
                              width:
                                  MediaQuery.of(context).size.width *
                                  0.1, // atur sesuai kebutuhan
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.2, // atur sesuai kebutuhan
                              fit: BoxFit.contain,
                            ),
                          ),

                        // Subtitle
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Text(
                            pages[index]["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Color(0xff2F80ED),
                              height: 1.6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // Bagian bawah: tombol navigasi + indikator
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol back hanya muncul jika bukan halaman pertama
                currentPage > 0
                    ? IconButton(
                        onPressed: () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                        ),
                      )
                    : const SizedBox(width: 48), // dummy biar rata

                const SizedBox(width: 70),

                // Indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.blueAccent,
                    dotColor: Colors.black26,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),

                const SizedBox(width: 70),

                // Tombol next / check
                IconButton(
                  onPressed: currentPage < pages.length - 1
                      ? () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      : () {
                          Get.to(LoginPage());
                        },
                  icon: Icon(
                    currentPage == pages.length - 1
                        ? Icons.check
                        : Icons.arrow_forward,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
