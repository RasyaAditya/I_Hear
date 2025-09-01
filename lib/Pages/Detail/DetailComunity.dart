import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailKomunitasPage extends StatelessWidget {
  final String nama;
  final String pengikut;
  final String gambar;
  final String icon;
  final String deskripsi;
  final String link;

  const DetailKomunitasPage({
    super.key,
    required this.nama,
    required this.pengikut,
    required this.gambar,
    required this.icon,
    required this.deskripsi,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5BC8FF), Color(0xFF3A80F7)], // warna gradasi
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          "Detail Komunitas",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(lebar * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama
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

            // Nama & pengikut
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(icon),
                    radius: 20,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: lebar * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nama,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),

                        Text(
                          " | ",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          pengikut,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: tinggi * 0.02),

            // Deskripsi
            Text(
              "Selamat Datang di Komunitas $nama",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: tinggi * 0.015),
            Text(
              deskripsi,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: tinggi * 0.2),

            // Tombol Bergabung
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(link);
                  try {
                    await launchUrl(
                      url,
                      mode: LaunchMode
                          .externalApplication, // 👈 penting biar buka WA
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Tidak bisa membuka link WhatsApp"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A80F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: Size(lebar * 0.7, tinggi * 0.06),
                ),
                child: Text(
                  "Bergabung",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
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
}
