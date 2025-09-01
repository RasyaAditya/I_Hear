import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

TextEditingController DisplayName = TextEditingController();
TextEditingController Kelamin = TextEditingController();

File? selectedImage;

/// Simpan data profile berdasarkan email
void saveProfileData(String email) async {
  final box = GetStorage();
  if (DisplayName.text.isNotEmpty && selectedImage != null) {
    box.write("Data_$email", {
      "DisplayName": DisplayName.text,
      "Image": selectedImage!.path,
    });
  }
}

/// Load data profile berdasarkan email
Future<void> loadProfileData(String email) async {
  final box = GetStorage();
  final data = box.read("Data_$email"); // pake email di key
  if (data != null) {
    DisplayName.text = data["DisplayName"] ?? "";
    if (data["Image"] != null) {
      selectedImage = File(data["Image"]);
    }
  } else {
    DisplayName.clear();
    selectedImage = null;
  }
}

/// Ambil gambar dari galeri
Future<File?> pickImageFromGallery() async {
  final returnedImage = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );
  if (returnedImage == null) return null;
  return File(returnedImage.path);
}

Future<File?> pickImageFromCamera() async {
  final returnedImage = await ImagePicker().pickImage(
    source: ImageSource.camera,
    preferredCameraDevice: CameraDevice.rear, // bisa juga CameraDevice.front
  );
  if (returnedImage == null) return null;
  return File(returnedImage.path);
}
