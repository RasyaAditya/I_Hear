import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Auth/LoginPage.dart';
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
      "image": "assets/images/ob1.png",
      "bot": "assets/Icon/botbiru.png",
      "title": "Halo, Aku SAPA!",
      "subtitle":
          "Perkenalkan Aku adalah SAPA, asisten virtual dari aplikasi IHEAR yang akan membantu kalian dalam berkomunikasi dengan lebih mudah. Aku senang bisa menemani kalian dalam setiap percakapan.",
    },
    {
      "image": "assets/images/ob2.png",
      "title": "Tanya Langsung #BarengSAPA",
      "subtitle":
          "Jika kalian mengalami kesulitan dalam berkomunikasi, jangan khawatir! Kalian bisa mengandalkan Aku kapan saja dan di mana saja untuk membantu menyampaikan pesan dengan lebih jelas.",
    },
    {
      "image": "assets/images/ob3.png",
      "title": "Komunikasi Jadi Lebih Mudah",
      "subtitle":
          "Dengan aplikasi IHEAR, kalian dapat berkomunikasi dengan lebih lancar. Kalian juga bisa belajar berbagai kosakata dan cara berkomunikasi yang lebih efektif setiap hari.",
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

                        // Subtitle
                        Positioned(
                          bottom: 80,
                          left: 35,
                          right: 35,
                          child: Text(
                            pages[index]["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
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
            padding: const EdgeInsets.only(bottom: 60.0, top: 20),
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
                          Get.to(ChatScreen());
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
