import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_hear/Pages/Auth/OtpScreen.dart';
import 'package:i_hear/Pages/Auth/OTPScreen.dart' hide OtpScreen;
import 'package:i_hear/Pages/Home/DaftarBerhasil.dart';
import 'package:i_hear/Controller/OTPController.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State untuk data form
  var email = ''.obs;
  var username = ''.obs;
  var phone = ''.obs;
  var password = ''.obs;
  var verificationId = ''.obs;

  // State untuk fungsionalitas kirim ulang
  int? resendToken;
  var timerIsActive = false.obs;
  var countdown = 60.obs;
  Timer? _timer;

  // Fungsi ini dipanggil dari Daftarpage
  void sendOtp({
    required String userEmail,
    required String userUsername,
    required String userPhone,
    required String userPassword,
  }) async {
    // Simpan data dari form ke controller
    email.value = userEmail;
    username.value = userUsername;
    phone.value = userPhone;
    password.value = userPassword;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await _auth.verifyPhoneNumber(
      phoneNumber: phone.value,
      // (1) Auto-retrieval: Jika Firebase bisa verifikasi otomatis
      verificationCompleted: (PhoneAuthCredential credential) async {
        await verifyOtpAndRegisterWithCredential(credential);
      },
      // (2) Gagal: Jika terjadi error
      verificationFailed: (FirebaseAuthException e) {
        Get.back();
        Get.snackbar(
          'Gagal',
          'Gagal mengirim OTP: ${e.message}',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      },
      // (3) Sukses: Jika OTP berhasil dikirim via SMS
      codeSent: (String verId, int? token) {
        verificationId.value = verId;
        resendToken = token;
        startTimer();
        Get.back();
        Get.to(() => OtpScreen());
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

  // Fungsi ini dipanggil dari OtpScreen (saat user input manual)
  void verifyOtpAndRegister(String otp) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _registerUser(credential);
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'invalid-verification-code') {
        Get.snackbar(
          'Gagal',
          'Kode OTP yang Anda masukkan salah.',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan: ${e.message}',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  // Fungsi ini dipanggil saat auto-retrieval berhasil
  Future<void> verifyOtpAndRegisterWithCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      await _registerUser(credential);
    } on FirebaseAuthException catch (e) {
      if (Get.isDialogOpen!) Get.back();
      Get.snackbar(
        'Gagal',
        'Verifikasi otomatis gagal: ${e.message}',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fungsi inti untuk mendaftarkan user, bisa dipanggil dari manual atau otomatis
  Future<void> _registerUser(PhoneAuthCredential credential) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.value,
      password: password.value,
    );

    await userCredential.user!.linkWithCredential(credential);

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'username': username.value,
      'namaLengkap': username.value,
      'nomorTelepon': phone.value,
      'email': email.value,
      'photoUrl': null,
      'createdAt': Timestamp.now(),
    });

    if (Get.isDialogOpen!) Get.back();
    Get.offAll(() => Daftarberhasil());
  }

  // Fungsi untuk kirim ulang OTP
  void resendOtp() async {
    if (resendToken == null) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await _auth.verifyPhoneNumber(
      phoneNumber: phone.value,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await verifyOtpAndRegisterWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.back();
        Get.snackbar('Gagal', 'Gagal mengirim ulang OTP: ${e.message}');
      },
      codeSent: (String verId, int? token) {
        verificationId.value = verId;
        resendToken = token;
        startTimer();
        Get.back();
        Get.snackbar('Berhasil', 'OTP telah dikirim ulang.');
      },
      codeAutoRetrievalTimeout: (String verId) {},
    );
  }

  void startTimer() {
    countdown.value = 60; // Reset countdown
    timerIsActive.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timerIsActive.value = false;
        _timer?.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
