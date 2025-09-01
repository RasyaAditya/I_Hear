import 'package:flutter/material.dart';
import 'package:i_hear/Pages/Home/Opening.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _fadeController;
  late Animation<double> _circleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isBackground = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Hitung ukuran max supaya nutup layar
    final size = MediaQuery.of(context).size;
    final maxSize = size.longestSide * 1.2; // lebihin dikit biar aman

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _circleAnimation = Tween<double>(begin: 50, end: maxSize).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeInOut),
    );

    // Jalankan animasi
    _circleController.forward();

    // Begitu selesai → langsung jadi background + jalanin fade logo
    _circleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isBackground = true;
        });
        _fadeController.forward();

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 2800),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const OpeningScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background putih dulu
          Container(color: Colors.white),

          // Circle animasi → berubah ke background
          if (!_isBackground)
            AnimatedBuilder(
              animation: _circleAnimation,
              builder: (context, child) {
                return Center(
                  child: Container(
                    width: _circleAnimation.value,
                    height: _circleAnimation.value,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                );
              },
            )
          else
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

          // Logo fade in
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/Icon/logoNewW.png",
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
