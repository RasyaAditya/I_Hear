import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// Diubah menjadi StatefulWidget untuk mengelola state tombol like/dislike
class DetailTempatPage extends StatefulWidget {
  final String namaTempat;
  final String kategori;
  final String gambar;
  final String deskripsi;
  final String instagram;
  final String maps;

  const DetailTempatPage({
    super.key,
    required this.namaTempat,
    required this.kategori,
    required this.gambar,
    required this.deskripsi,
    required this.instagram,
    required this.maps,
  });

  @override
  State<DetailTempatPage> createState() => _DetailTempatPageState();
}

class _DetailTempatPageState extends State<DetailTempatPage> {
  // State untuk melacak status tombol like dan dislike
  bool isLiked = false;
  bool isDisliked = false;

  // Helper function untuk membuka URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Tidak dapat membuka $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;
    final tinggi = MediaQuery.of(context).size.height;

    // Style untuk tombol agar konsisten (padding diperkecil)
    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: BorderSide(color: Colors.blue.shade400),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ), // Diperkecil
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Detail Tempat",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
                widget.gambar, // Menggunakan 'widget.' untuk akses properti
                width: double.infinity,
                height: tinggi * 0.25,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: tinggi * 0.02),

            // Nama tempat & kategori
            Text(
              widget.namaTempat,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.kategori,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
            ),
            SizedBox(height: tinggi * 0.02),

            // ========================================================== //
            // ========== BAGIAN YANG DIPERBARIKI MULAI DARI SINI ========== //
            // ========================================================== //
            Row(
              children: [
                // Tombol Like & Dislike yang digabung
                Container(
                  height: 36, // Tinggi diperkecil
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.blue.shade400, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Like
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked; // Toggle status like
                            if (isLiked) {
                              isDisliked =
                                  false; // Nonaktifkan dislike jika like aktif
                            }
                          });
                        },
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ), // Padding diperkecil
                          child: Icon(
                            isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined, // Icon berubah
                            color: Colors.blue,
                            size: 18, // Ukuran icon diperkecil
                          ),
                        ),
                      ),
                      // Garis Pemisah
                      VerticalDivider(
                        color: Colors.blue.shade400,
                        width: 1,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                      ),
                      // Tombol Dislike
                      InkWell(
                        onTap: () {
                          setState(() {
                            isDisliked = !isDisliked; // Toggle status dislike
                            if (isDisliked) {
                              isLiked =
                                  false; // Nonaktifkan like jika dislike aktif
                            }
                          });
                        },
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ), // Padding diperkecil
                          child: Icon(
                            isDisliked
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined, // Icon berubah
                            color: Colors.blue,
                            size: 18, // Ukuran icon diperkecil
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Tombol Instagram
                OutlinedButton.icon(
                  onPressed: () {
                    _launchURL(widget.instagram);
                  },
                  icon: Image.asset("assets/Icon/instagram.png"),
                  label: Text(
                    "Instagram",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ), // Font diperkecil
                  ),
                  style: buttonStyle,
                ),

                const SizedBox(width: 8),

                // Tombol Lokasi
                OutlinedButton.icon(
                  onPressed: () {
                    _launchURL(widget.maps);
                  },
                  icon: const Icon(Icons.location_on_outlined, size: 18),
                  label: Text(
                    "Lokasi",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ), // Font diperkecil
                  ),
                  style: buttonStyle,
                ),
              ],
            ),
            // ======================================================== //
            // ========== BAGIAN YANG DIPERBARIKI SELESAI ========== //
            // ======================================================== //
            SizedBox(height: tinggi * 0.02),

            // Deskripsi
            Text(
              widget.deskripsi,
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
