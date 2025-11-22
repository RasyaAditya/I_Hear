import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_hear/Pages/Auth/DaftarPage.dart';
import 'package:i_hear/Pages/Home/LoginSukses.dart';
import '../../Models/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                "Masuk",
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.065,
                  color: const Color(0xFF2F80ED),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "Selamat datang kembali,\nKami merindukan Anda!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.045,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: size.height * 0.10),

              Expanded(
                child: Column(
                  children: [
                    _buildInputField(email, "Email", false, size),
                    SizedBox(height: size.height * 0.02),
                    _buildInputField(password, "Kata Sandi", true, size),
                    SizedBox(height: size.height * 0.01),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text.rich(
                        TextSpan(
                          text: 'Lupa kata sandi?',
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.032,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.snackbar(
                                'Informasi',
                                'Fitur lupa kata sandi belum tersedia.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                            },
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),

                    // Tombol login
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80ED),
                        ),
                        child: Text(
                          "Masuk",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.05,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    // Link daftar
                    Text.rich(
                      TextSpan(
                        text: 'Tidak memiliki akun? ',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.032,
                          color: const Color(0xFF494949),
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Daftar',
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.032,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(const Daftarpage()),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.1),

                    Text(
                      "Atau lanjutkan dengan",
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.028,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(FontAwesomeIcons.google, size),
                        SizedBox(width: size.width * 0.02),
                        _buildSocialButton(FontAwesomeIcons.facebookF, size),
                        SizedBox(width: size.width * 0.02),
                        _buildSocialButton(FontAwesomeIcons.apple, size),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input Field
  Widget _buildInputField(
    TextEditingController controller,
    String hint,
    bool isPassword,
    Size size,
  ) {
    return SizedBox(
      height: size.height * 0.065,
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isHidden : false,
        style: GoogleFonts.poppins(fontSize: size.width * 0.04),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: size.width * 0.04),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF1F4FF),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.015,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 2),
          ),
        ),
      ),
    );
  }

  // Social Button Dummy
  Widget _buildSocialButton(IconData icon, Size size) {
    return Container(
      height: size.height * 0.050,
      width: size.width * 0.15,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.black87, size: size.width * 0.05),
    );
  }

  // Handle Login
  void _handleLogin() async {
    String mail = email.text.trim();
    String pass = password.text.trim();

    if (mail.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email / Password tidak boleh kosong')),
      );
      return;
    }

    try {
      // 1) Login ke Firebase Auth
      await authService.value.signIn(email: mail, password: pass);

      // 2) Ambil user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User null setelah login");

      // 3) Ambil data profil dari Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      Map<String, dynamic> profileData = {};
      if (doc.exists) {
        final data = doc.data()!;
        profileData = {
          'DisplayName': data['username'] ?? user.displayName ?? '',
          'Image': data['imageUrl'] ?? null,
          'Phone': data['phone'] ?? '',
        };
      } else {
        profileData = {
          'DisplayName':
              user.displayName ?? user.email?.split('@').first ?? 'Pengguna',
          'Image': null,
          'Phone': '',
        };
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': profileData['DisplayName'],
          'phone': '',
          'imageUrl': '',
          'email': user.email,
        }, SetOptions(merge: true));
      }

      // 4) Simpan ke GetStorage
      final box = GetStorage();
      await box.write('Data_${user.email}', profileData);

      // 5) Navigasi ke home
      Get.offAll(const LoginSuccessPage());
    } catch (err) {
      print("Login error: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal. Periksa kembali data Anda.'),
        ),
      );
    }
  }
}
