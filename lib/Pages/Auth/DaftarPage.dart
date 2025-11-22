// Daftarpage.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:i_hear/Models/auth_service.dart';
import 'package:i_hear/Pages/Auth/MasukPage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- UBAH/TAMBAHKAN INI
import 'package:i_hear/Pages/Auth/OtpPage.dart';   // <-- TAMBAHKAN INI
import 'package:shared_preferences/shared_preferences.dart';

class Daftarpage extends StatefulWidget {
  const Daftarpage({super.key});

  @override
  State<Daftarpage> createState() => _DaftarpageState();
}

 class _DaftarpageState extends State<Daftarpage> {
  // Controller
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phone = TextEditingController();

  // State
  bool isChecked = false;
  bool isHiddenPassword = true;
  bool isHiddenConfirm = true;
  bool isLoading = false; // <-- TAMBAHKAN STATE LOADING

  // --- FUNGSI BARU UNTUK MEMULAI VERIFIKASI TELEPON ---
  Future<void> _verifyPhoneNumber() async {
    // 1. Validasi semua input terlebih dahulu
    String mail = email.text.trim();
    String uname = username.text.trim();
    String pass = password.text.trim();
    String confirmPass = confirmPassword.text.trim();
    String phoneNum = phone.text.trim();
    

    if (mail.isEmpty ||
        uname.isEmpty ||
        pass.isEmpty ||
        confirmPass.isEmpty ||
        phoneNum.isEmpty) {
      Get.snackbar('Gagal', 'Semua kolom wajib diisi.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (!GetUtils.isEmail(mail)) {
      Get.snackbar('Gagal', 'Format email tidak valid.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (pass != confirmPass) {
      Get.snackbar('Gagal', 'Kata sandi dan konfirmasi tidak cocok.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // 2. Tampilkan loading
    setState(() {
      isLoading = true;
    });

    // 3. Format nomor telepon ke standar internasional (+62)
    String fullPhoneNumber = "+62$phoneNum";

    // 4. Panggil Firebase Auth untuk mengirim OTP
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Callback ini untuk auto-verification di Android, jarang terjadi
        setState(() {
          isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        // Callback jika terjadi error (misal: nomor tidak valid)
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Gagal Mengirim OTP', 'Terjadi kesalahan: ${e.message}',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      },
      // ... di dalam _verifyPhoneNumber
codeSent: (String verificationId, int? resendToken) {
  setState(() {
    isLoading = false;
  });
  // Pindah ke halaman OTP dengan membawa semua data yang diperlukan
  Get.to(() => OtpPage(
        verificationId: verificationId,
        resendToken: resendToken, // <-- TAMBAHKAN BARIS INI
        email: mail,
        username: uname,
        password: pass,
        phone: fullPhoneNumber,
      ));
},
// ...
      codeAutoRetrievalTimeout: (String verificationId) {
        // Callback jika waktu tunggu habis
      },
      timeout: const Duration(seconds: 60),
    );
  }

  // --- TIDAK ADA PERUBAHAN PADA UI WIDGET DI BAWAH INI ---
  // --- HANYA LOGIKA PADA TOMBOL `_buildMainButton` YANG BERUBAH ---

  @override
  Widget build(BuildContext context) {
    // ... Seluruh kode build method Anda tidak berubah ...
    // (Tidak disalin ulang agar fokus pada perubahan utama)
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.1),
          child: Column(
            children: [
              SizedBox(height: media.height * 0.05),
              Text(
                "Daftar",
                style: GoogleFonts.poppins(
                  fontSize: media.width * 0.065,
                  color: const Color(0xFF2F80ED),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: media.height * 0.005),
              Text(
                "Membuat akun dan dapatkan \n fitur-fitur yang menarik",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: media.width * 0.032,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: media.height * 0.06),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildInput(email, "Email", false, media),
                      SizedBox(height: media.height * 0.015),
                      _buildInput(username, "Nama Pengguna", false, media),
                      SizedBox(height: media.height * 0.015),
                      _buildPasswordInput(
                        password,
                        "Kata Sandi",
                        isHiddenPassword,
                        () {
                          setState(() {
                            isHiddenPassword = !isHiddenPassword;
                          });
                        },
                        media,
                      ),
                      SizedBox(height: media.height * 0.015),
                      _buildPasswordInput(
                        confirmPassword,
                        "Konfirmasi Kata Sandi",
                        isHiddenConfirm,
                        () {
                          setState(() {
                            isHiddenConfirm = !isHiddenConfirm;
                          });
                        },
                        media,
                      ),
                      SizedBox(height: media.height * 0.015),
                      _buildPhoneInput(media),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                              activeColor: const Color(0xFF2F80ED),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Text(
                              "Ingatkan saya",
                              style: GoogleFonts.poppins(
                                fontSize: media.width * 0.025,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: media.height * 0.01),
                      _buildMainButton(media), // Logika di dalamnya diubah
                      SizedBox(height: media.height * 0.04),
                      Text.rich(
                        TextSpan(
                          text: 'Sudah memiliki akun? ',
                          style: GoogleFonts.poppins(
                            fontSize: media.width * 0.030,
                            color: const Color(0xFF494949),
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Masuk',
                              style: GoogleFonts.poppins(
                                fontSize: media.width * 0.030,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(const MasukPage());
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: media.height * 0.07),
                      Text(
                        "Atau lanjutkan dengan",
                        style: GoogleFonts.poppins(
                          fontSize: media.width * 0.028,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: media.height * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(FontAwesomeIcons.google, media),
                          SizedBox(width: media.width * 0.02),
                          _buildSocialButton(FontAwesomeIcons.facebookF, media),
                          SizedBox(width: media.width * 0.02),
                          _buildSocialButton(FontAwesomeIcons.apple, media),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: media.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(Size media) {
    return SizedBox(
      width: double.infinity,
      height: media.height * 0.065,
      // --- MODIFIKASI BAGIAN INI ---
      child: ElevatedButton(
        onPressed: isLoading ? null : _verifyPhoneNumber,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F80ED),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Daftar",
                style: GoogleFonts.poppins(
                  fontSize: media.width * 0.045,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  // --- Widget-widget lain tidak perlu diubah sama sekali ---
  // ... _buildInput, _buildPasswordInput, _buildPhoneInput, _buildSocialButton ...
  // (Sengaja tidak disalin ulang karena tidak ada perubahan)
  Widget _buildInput(
    TextEditingController controller,
    String hint,
    bool isPassword,
    Size media,
  ) {
    return SizedBox(
      height: media.height * 0.07,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF1F4FF),
          contentPadding: EdgeInsets.symmetric(
            horizontal: media.width * 0.04,
            vertical: media.height * 0.018,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: media.width * 0.035,
            color: const Color(0xFF626262),
            fontWeight: FontWeight.w500,
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

  Widget _buildPasswordInput(
    TextEditingController controller,
    String hint,
    bool isHidden,
    VoidCallback toggle,
    Size media,
  ) {
    return SizedBox(
      height: media.height * 0.07,
      child: TextField(
        controller: controller,
        obscureText: isHidden,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF1F4FF),
          contentPadding: EdgeInsets.symmetric(
            horizontal: media.width * 0.04,
            vertical: media.height * 0.018,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: media.width * 0.035,
            color: const Color(0xFF626262),
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isHidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggle,
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

  Widget _buildPhoneInput(Size media) {
    return SizedBox(
      height: media.height * 0.07,
      child: TextField(
        controller: phone,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: "+62 | Masukkan Nomor Telepon Anda",
          filled: true,
          fillColor: const Color(0xFFF1F4FF),
          contentPadding: EdgeInsets.symmetric(
            horizontal: media.width * 0.04,
            vertical: media.height * 0.018,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: media.width * 0.035,
            color: const Color(0xFF626262),
            fontWeight: FontWeight.w500,
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

  Widget _buildSocialButton(IconData icon, Size media) {
    return Container(
      height: media.height * 0.045,
      width: media.width * 0.15,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.black87, size: media.width * 0.05),
    );
  }
}

