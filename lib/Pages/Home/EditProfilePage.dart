import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = FirebaseAuth.instance.currentUser;
  final box = GetStorage();

  File? selectedImage;
  final usernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  String? uploadedUrl;

  @override
  void initState() {
    super.initState();
    _checkEmailChange();
    _loadProfileData();
  }

  void _checkEmailChange() {
    String? lastEmail = box.read("lastEmail");
    if (lastEmail != user?.email) {
      box.write("lastEmail", user?.email);
    }
  }

  Future<void> _loadProfileData() async {
    if (user == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          usernameController.text = data["username"] ?? "";
          uploadedUrl = data["imageUrl"];
        });
      }
    } catch (e) {
      print("❌ Error load profile: $e");
    }
  }

  Future<File?> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> uploadProfileData() async {
    if (user == null) return;

    try {
      // Upload foto kalau ada
      if (selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("profile_images")
            .child(user!.uid)
            .child("profile.jpg");

        await storageRef.putFile(selectedImage!);
        uploadedUrl = await storageRef.getDownloadURL();
        print("✅ Image uploaded: $uploadedUrl");
      }

      // Ambil password lama & baru
      final oldPassword = oldPasswordController.text.trim();
      final newPassword = newPasswordController.text.trim();

      if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
        final cred = EmailAuthProvider.credential(
          email: user!.email!,
          password: oldPassword,
        );

        // Re-authenticate
        await user!.reauthenticateWithCredential(cred);

        // Update password
        await user!.updatePassword(newPassword);
        print("✅ Password updated di FirebaseAuth");
      }

      // Update Firestore (username & foto)
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "username": usernameController.text,
        "email": user!.email,
        "imageUrl": uploadedUrl ?? "",
      }, SetOptions(merge: true));

      Get.snackbar(
        "Sukses",
        "Profil berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back(result: true);
    } catch (e) {
      print("❌ Error upload profile: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // ✅ FIX size

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.05),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : (uploadedUrl != null && uploadedUrl!.isNotEmpty)
                        ? NetworkImage(uploadedUrl!)
                        : const AssetImage("assets/images/fotoProfil.png")
                              as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F80ED),
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
                        icon: const Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Input Nama
            _buildTextField(usernameController, "Nama Lengkap"),

            const SizedBox(height: 20),

            // Input Password Lama & Baru
            _buildInputField(
              oldPasswordController,
              "Password Lama",
              true,
              size,
            ),
            SizedBox(height: size.height * 0.02),
            _buildInputField(
              newPasswordController,
              "Password Baru",
              true,
              size,
            ),

            const SizedBox(height: 30),

            // Tombol Upload
            SizedBox(
              width: 145,
              height: 40,
              child: ElevatedButton(
                onPressed: uploadProfileData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Color(0xFF2F80ED), width: 2),
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
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
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
            borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint,
    bool isPassword,
    Size size,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
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
            borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 2),
          ),
        ),
      ),
    );
  }
}
