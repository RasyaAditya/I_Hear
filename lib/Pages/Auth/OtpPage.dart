import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_hear/Models/auth_service.dart';
import 'package:i_hear/Pages/Home/DaftarBerhasil.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final int? resendToken; // <-- TAMBAHKAN INI
  final String email;
  final String username;
  final String password;
  final String phone;

  const OtpPage({
    super.key,
    required this.verificationId,
    this.resendToken, // <-- DAN TAMBAHKAN INI
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isLoading = false;
  bool isResending = false;
  late String _currentVerificationId;
  int? _currentResendToken; // Simpan token untuk kirim ulang

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    _currentResendToken = widget.resendToken;
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length > 4) {
      return "${phoneNumber.substring(0, phoneNumber.length - 4).replaceAll(RegExp(r'.'), '*')} ${phoneNumber.substring(phoneNumber.length - 4)}";
    }
    return phoneNumber;
  }

  Future<void> _resendOtp() async {
    setState(() {
      isResending = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        forceResendingToken: _currentResendToken, // Gunakan token
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar(
            'Gagal Kirim Ulang',
            e.message ?? "Terjadi kesalahan",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _currentVerificationId = verificationId;
            _currentResendToken = resendToken; // Update token yang baru
          });
          Get.snackbar(
            'Berhasil',
            'Kode OTP baru telah dikirimkan.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } finally {
      setState(() {
        isResending = false;
      });
    }
  }

  Future<void> _verifyOtpAndRegister() async {
    if (otpController.text.length != 6) {
      Get.snackbar(
        'Error',
        'Harap masukkan 6 digit kode OTP.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _currentVerificationId,
        smsCode: otpController.text,
      );

      final userCredential = await authService.value.createAccount(
        email: widget.email,
        password: widget.password,
      );

      final user = userCredential.user;

      if (user != null) {
        // Tautkan kredensial telepon ke akun yang baru dibuat
        await user.linkWithCredential(credential);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': widget.email,
          'username': widget.username,
          'password': widget.password,
          'phone': widget.phone,
          'isPhoneVerified': true,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Hapus password dari penyimpanan lokal setelah berhasil
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.remove('password');

        Get.offAll(() => Daftarberhasil());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Terjadi kesalahan.";
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'Kode OTP yang Anda masukkan salah.';
      } else if (e.code == 'credential-already-in-use') {
        errorMessage = 'Nomor telepon ini sudah ditautkan ke akun lain.';
      }
      Get.snackbar(
        'Verifikasi Gagal',
        errorMessage,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (err) {
      Get.snackbar(
        'Gagal',
        'Tidak bisa membuat akun. $err',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.poppins(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2F80ED)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ganti dengan path aset Anda jika ada
                Icon(
                  Icons.shield_moon,
                  size: media.height * 0.15,
                  color: Color(0xFF2F80ED),
                ),
                SizedBox(height: media.height * 0.04),
                Text(
                  "Verifikasi Kode OTP",
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.065,
                    color: const Color(0xFF2F80ED),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: media.height * 0.01),
                Text(
                  "Masukkan 6 digit kode yang dikirimkan ke nomor Anda ${maskPhoneNumber(widget.phone)}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: media.height * 0.05),
                Pinput(
                  length: 6,
                  controller: otpController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: const Color(0xFF2F80ED)),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.green),
                    ),
                  ),
                  onCompleted: (pin) {
                    _verifyOtpAndRegister();
                  },
                ),
                SizedBox(height: media.height * 0.05),
                SizedBox(
                  width: double.infinity,
                  height: media.height * 0.065,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _verifyOtpAndRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Verifikasi",
                            style: GoogleFonts.poppins(
                              fontSize: media.width * 0.045,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: media.height * 0.03),
                Text(
                  "Tidak menerima kode?",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
                TextButton(
                  onPressed: isResending ? null : _resendOtp,
                  child: isResending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          "Kirim Ulang",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2F80ED),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
