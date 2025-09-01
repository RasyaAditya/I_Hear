import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:i_hear/Models/auth_service.dart';
import 'package:i_hear/Pages/Auth/MasukPage.dart';
import 'package:i_hear/Pages/Home/DaftarBerhasil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Daftarpage extends StatefulWidget {
  const Daftarpage({super.key});

  @override
  State<Daftarpage> createState() => _DaftarpageState();
}

class _DaftarpageState extends State<Daftarpage> {
  // Controller
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  // State
  bool isChecked = false;
  bool isHiddenPassword = true;
  bool isHiddenConfirm = true;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.1),
          child: Column(
            children: [
              SizedBox(height: media.height * 0.1),
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
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildInput(email, "Email", false, media),
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
                      _buildMainButton(media),
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

  Widget _buildMainButton(Size media) {
    return SizedBox(
      width: double.infinity,
      height: media.height * 0.065,
      child: ElevatedButton(
        onPressed: () async {
          String mail = email.text.trim();
          String pass = password.text.trim();
          String confirmPass = confirmPassword.text.trim();

          if (mail.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Semua kotak harus terisi')),
            );
            return;
          }

          if (pass != confirmPass) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password tidak sama')),
            );
            return;
          }

          try {
            await authService.value.createAccount(email: mail, password: pass);

            // simpan kalau checkbox dicentang
            if (isChecked) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('email', mail);
              await prefs.setString('password', pass);
            }

            // snackbar sukses
            // Get.snackbar(
            //   'Berhasil',
            //   'Akun berhasil didaftarkan!',
            //   snackPosition: SnackPosition.TOP,
            //   backgroundColor: Colors.greenAccent,
            //   colorText: Colors.white,
            //   icon: const Icon(Icons.check_circle, color: Colors.white),
            //   margin: const EdgeInsets.all(15),
            //   borderRadius: 12,
            //   duration: const Duration(seconds: 3),
            // );

            // langsung pindah
            Get.to(() => Daftarberhasil());
          } catch (err) {
            print("Error daftar: $err");
            Get.snackbar(
              'Gagal',
              'Tidak bisa membuat akun. $err',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              icon: const Icon(Icons.error, color: Colors.white),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F80ED),
        ),
        child: Text(
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
