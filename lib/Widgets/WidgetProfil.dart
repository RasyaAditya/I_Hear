import 'dart:io';
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
  String? email;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final box = GetStorage();
    final data = box.read("Data_${user?.email}");

    if (data != null) {
      setState(() {
        displayName = data["DisplayName"] ?? "Pengguna";
        if (data["Image"] != null) {
          profileImage = File(data["Image"]);
        }
      });
    } else {
      displayName = user?.email ?? "Pengguna";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : AssetImage("assets/images/fotoProfil.png")
                              as ImageProvider,
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            // Nama dari GetStorage
            Center(
              child: Text(
                displayName ?? "Pengguna",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Email dari Firebase
            Center(
              child: Text(
                user?.email ?? 'Email tidak tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF595959),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.height * 0.045,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updated = await Get.to(EditProfile());
                      if (updated == true) {
                        _loadProfileData(); // refresh data
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2F80ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Edit Profil",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.height * 0.045,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      side: BorderSide(color: Color(0xFF2F80ED), width: 2),
                    ),
                    child: Text(
                      "Daftar Teman",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F80ED),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Pengaturan Notifikasi",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        print("Pengaturan Notifikasi diklik");
                      },
                    ),
                    Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
                    ListTile(
                      title: Text(
                        "Pengaturan Privasi",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        print("Pengaturan Privasi diklik");
                      },
                    ),
                    Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
                    ListTile(
                      title: Text(
                        "Mengajukan Pertanyaan",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        print("Mengajukan Pertanyaan diklik");
                      },
                    ),
                    Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
                    ListTile(
                      title: Text(
                        "Kebijakan Privasi",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        print("Kebijakan Privasi diklik");
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Tombol Logout
            SizedBox(height: 20),
            SizedBox(
              width: 145,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  final box = GetStorage();
                  await authService.value.signOut().then((_) async {
                    Get.deleteAll(); // hapus semua dependency GetX
                    Get.offAll(LoginPage());
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  "Keluar",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "Versi 1.0.0",
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "© SMK26JKT Team and Developer. All rights Reversed",
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
