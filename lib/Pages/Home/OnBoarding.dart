import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Home/ChatBot.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/Ihearsosmed3.png",
      "title": "Halo, Aku SAPA!",
      "subtitle":
          "Perkenalkan, Aku adalah SAPA, asisten virtual dari aplikasi iHEAR yang akan membantu kalian dalam berkomunikasi dengan lebih mudah. Aku senang bisa menemani kalian dalam setiap percakapan.",
    },
    {
      "image": "assets/images/Ihearsosmed1.png",
      "title": "Tanya Langsung #BarengSAPA",
      "subtitle":
          "Jika kalian mengalami kesulitan dalam berkomunikasi, jangan khawatir! Kalian bisa mengandalkan Aku kapan saja dan di mana saja untuk membantu menyampaikan pesan dengan lebih jelas.",
    },
    {
      "image": "assets/images/Ihearsosmed2.png",
      "title": "Komunikasi Jadi Lebih Mudah",
      "subtitle":
          "Dengan aplikasi iHEAR, kalian dapat berkomunikasi dengan lebih lancar. Kalian juga bisa belajar berbagai kosakata dan cara berkomunikasi yang lebih efektif setiap hari.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => currentPage = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  // Bagian gambar full + lekukan
                  ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.55,
                      color: Colors.white,
                      child: Image.asset(
                        pages[index]["image"]!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover, // biar full ke samping & atas
                      ),
                    ),
                  ),

                  // Bagian teks judul + subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          pages[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pages[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Bagian bawah (indicator + tombol navigasi)
          // Bagian bawah (indicator + tombol navigasi)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol kiri
                IconButton(
                  onPressed: currentPage > 0
                      ? () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),

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

                // Tombol kanan
                IconButton(
                  onPressed: currentPage < pages.length - 1
                      ? () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      : () {
                          Get.to(ChatScreen());
                        },
                  icon: Icon(
                    currentPage == pages.length - 1
                        ? Icons
                              .arrow_forward // kalau sudah di slide terakhir
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

// Custom clipper untuk lekukan bawah gambar
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
