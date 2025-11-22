import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/Home/EditProfilePage.dart';
import 'package:i_hear/Models/auth_service.dart';
import 'package:i_hear/Pages/Auth/LoginPage.dart';

class WidgetProfil extends StatefulWidget {
  const WidgetProfil({super.key});

  @override
  State<WidgetProfil> createState() => _WidgetProfilState();
}

class _WidgetProfilState extends State<WidgetProfil> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? displayName;
  File? profileImage;
  String? phoneNumber;
  String? password;
  String? imageUrl;
  bool _isPasswordVisible = false; // buat toggle lihat/smbunyi password

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    final uid = user?.uid;
    if (uid == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        print("Data Firestore: $data"); // Debugging

        setState(() {
          displayName = data["username"] ?? "Pengguna";
          phoneNumber = data["phone"] ?? "-";
          password = data["password"] ?? "-"; // ⚠️ sebaiknya jangan plain text
          imageUrl = data["imageUrl"]; // ambil URL gambar dari Firestore
        });
      } else {
        setState(() {
          displayName = user?.email ?? "Pengguna";
        });
      }
    } catch (e) {
      print("Error load profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;
    final tinggi = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data profil tidak ditemukan"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final displayName = data["username"] ?? "Pengguna";
          final email = data["email"] ?? "Email tidak tersedia";
          final password = data["password"] ?? "-";
          final imageUrl = data["imageUrl"];

          return SingleChildScrollView(
            padding: EdgeInsets.all(lebar * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER PROFIL
                Row(
                  children: [
                    CircleAvatar(
                      radius: lebar * 0.06,
                      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const AssetImage("assets/images/fotoProfil.png")
                                as ImageProvider,
                    ),
                    SizedBox(width: lebar * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: GoogleFonts.poppins(
                              fontSize: lebar * 0.038,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                              fontSize: lebar * 0.030,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: tinggi * 0.03),

                // INFORMASI PRIBADI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Informasi Pribadi",
                      style: GoogleFonts.poppins(
                        fontSize: lebar * 0.034,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Get.to(() => const EditProfile());
                        if (result == true) {
                          // reload data dari Firestore
                          _loadProfileData();
                          setState(() {});
                        }
                      },
                      child: Text(
                        "Edit Profil",
                        style: GoogleFonts.poppins(
                          fontSize: lebar * 0.030,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2F80ED),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: tinggi * 0.01),

                _infoRow(displayName, lebar),
                _infoRow(email, lebar),
                _infoRow(phoneNumber ?? "-", lebar),
                PasswordRow(password: password, lebar: lebar),

                SizedBox(height: tinggi * 0.03),

                // INFORMASI APLIKASI
                Text(
                  "Informasi Aplikasi",
                  style: GoogleFonts.poppins(
                    fontSize: lebar * 0.034,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: tinggi * 0.01),
                _menuItem("Tentang Kami", lebar, () {}),
                _menuItem("Pengaturan Notifikasi", lebar, () {}),
                _menuItem("Pengaturan Privasi", lebar, () {}),
                _menuItem("Mengajukan Pertanyaan", lebar, () {}),
                _menuItem("Kebijakan Privasi", lebar, () {}),

                SizedBox(height: tinggi * 0.03),

                // TOMBOL KELUAR
                SizedBox(
                  width: double.infinity,
                  height: tinggi * 0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      await authService.value.signOut().then((_) async {
                        Get.deleteAll();
                        Get.offAll(LoginPage());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(lebar * 0.1),
                      ),
                    ),
                    child: Text(
                      "Keluar",
                      style: GoogleFonts.poppins(
                        fontSize: lebar * 0.034,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: tinggi * 0.03),

                // FOOTER
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Versi App 1.3.7 Build 4708090",
                        style: GoogleFonts.poppins(
                          fontSize: lebar * 0.027,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: tinggi * 0.005),
                      Text(
                        "© SMK26JKT Team and Developer. All rights Reserved",
                        style: GoogleFonts.poppins(
                          fontSize: lebar * 0.027,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tinggi * 0.05),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String text, double lebar) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: lebar * 0.028,
        horizontal: lebar * 0.02,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: lebar * 0.031,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _menuItem(String title, double lebar, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: lebar * 0.032,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: lebar * 0.05,
          ),
          onTap: onTap,
        ),
        Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),
      ],
    );
  }
}

class PasswordRow extends StatefulWidget {
  final String password;
  final double lebar;

  const PasswordRow({super.key, required this.password, required this.lebar});

  @override
  State<PasswordRow> createState() => _PasswordRowState();
}

class _PasswordRowState extends State<PasswordRow> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.lebar * 0.010,
        horizontal: widget.lebar * 0.02,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isPasswordVisible ? widget.password : "●●●●●●●●",
            style: GoogleFonts.poppins(
              fontSize: widget.lebar * 0.031,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              size: widget.lebar * 0.05,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ],
      ),
    );
  }
}
