import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_hear/Controller/EditProfileController.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isHidden = true;
  final box = GetStorage();
  final user = FirebaseAuth.instance.currentUser;
  String email = "";

  @override
  void initState() {
    super.initState();
    _checkEmailChange();
  }

  void _checkEmailChange() {
    String? lastEmail = box.read("lastEmail");

    // Kalau email terakhir beda atau belum tersimpan → reset semua data
    if (lastEmail != user?.email) {
      box.write("lastEmail", user?.email); // simpan email baru
    } else if (lastEmail == null) {
      box.write(
        "lastEmail",
        user?.email,
      ); // kalau belum ada, simpan pertama kali
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.03,
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : AssetImage("assets/images/fotoProfil.png")
                            as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF2F80ED),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        File? image = await pickImageFromGallery();
                        if (image != null) {
                          setState(() {
                            selectedImage = image;
                          });
                        }
                      },
                      icon: Image.asset("assets/Icon/PhotoIcon.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: TextField(
                    controller: DisplayName,
                    decoration: InputDecoration(
                      hintText: "Nama",
                      filled: true,
                      fillColor: const Color(0xFFF1F4FF),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF2F80ED),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container(
            width: 145,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (user?.email != null) {
                  saveProfileData(user!.email!); // simpan ke GetStorage
                }
                Get.back(result: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2F80ED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Color(0xFF2F80ED), width: 2),
                ),
              ),
              child: Text(
                "Upload",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
