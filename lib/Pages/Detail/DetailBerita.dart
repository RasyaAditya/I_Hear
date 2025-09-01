import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailBeritaPage extends StatelessWidget {
  final String judul;
  final String gambar;
  final String deskripsi;
  final String logoBerita;
  final String namaBerita;
  final String waktu;

  const DetailBeritaPage({
    super.key,
    required this.judul,
    required this.logoBerita,
    required this.gambar,
    required this.namaBerita,
    required this.waktu,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;
    final tinggi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Detail Artikel",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(lebar * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                gambar,
                width: double.infinity,
                height: tinggi * 0.25,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: tinggi * 0.02),

            // Logo sumber berita + waktu
            Row(
              children: [
                Image.asset(
                  logoBerita, // contoh logo, bisa dynamic juga
                  width: 25,
                  height: 25,
                ),
                SizedBox(width: 8),
                Text(
                  "$namaBerita | $waktu", // contoh static
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: tinggi * 0.02),

            // Judul berita

            // Isi berita
            Text(
              deskripsi,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
