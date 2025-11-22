import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/WidgetProfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:i_hear/Pages/Detail/DetailComunity.dart';

class WidgetComunity extends StatefulWidget {
  final VoidCallback? onProfileTap;
  const WidgetComunity({this.onProfileTap, super.key});

  @override
  State<WidgetComunity> createState() => _WidgetComunityState();
}

class _WidgetComunityState extends State<WidgetComunity> {
  String kategoriAktif = "Semua";
  String cari = "";
  String phoneNumber = "-";
  String? imageUrl;

  final List<Map<String, String>> komunitas = [
    {
      "nama": "DeafTalk",
      "pengikut": "210 Pengikut",
      "gambar": "assets/images/komunitas1.png",
      "icon": "assets/Icon/c1.png",
      "deskripsi":
          "Deaf Talk adalah komunitas yang mendukung dan memberdayakan individu tuli dan bisu melalui edukasi, komunikasi, dan advokasi. Kami meningkatkan kesadaran, menyediakan dukungan, serta mendorong kebijakan inklusif.",
      "kategori": "Acara",
      "link": "https://whatsapp.com/channel/0029Van6EkM7j6gA3gwjVP0d",
    },
    {
      "nama": "Isyarat 101",
      "pengikut": "152 Pengikut",
      "gambar": "assets/images/komunitas2.png",
      "icon": "assets/Icon/c2.png",
      "deskripsi":
          "Isyarat 101 adalah komunitas yang berfokus pada pembelajaran bahasa isyarat dari tingkat dasar hingga mahir. Kami menyediakan materi edukatif, sesi latihan, serta diskusi interaktif untuk membantu siapa saja yang ingin memahami dan menggunakan bahasa isyarat dengan lebih baik. Bergabunglah untuk belajar dan mendukung komunikasi yang lebih inklusif!",
      "kategori": "Webinar",
      "link": "https://whatsapp.com/channel/0029Van6EkM7j6gA3gwjVP0d",
    },
    {
      "nama": "Senyum Isyarat",
      "pengikut": "500 Pengikut",
      "gambar": "assets/images/komunitas3.png",
      "icon": "assets/Icon/c3.png",
      "deskripsi":
          "Senyum Isyarat adalah komunitas yang menghubungkan individu tuli dan bisu dengan berbagai kegiatan sosial, edukasi, dan dukungan. Kami percaya bahwa setiap orang berhak mendapatkan akses informasi dan kesempatan yang setara. Bergabunglah untuk berbagi pengalaman, belajar, dan tumbuh bersama!",
      "kategori": "Promosi",
      "link": "https://whatsapp.com/channel/0029Van6EkM7j6gA3gwjVP0d",
    },
    {
      "nama": "Teman Isyarat",
      "pengikut": "738 Pengikut",
      "gambar": "assets/images/komunitas4.png",
      "icon": "assets/Icon/c4.png",
      "deskripsi":
          "Teman Isyarat adalah ruang komunitas bagi individu tuli dan teman dengar untuk berbagi pengalaman, berdiskusi, dan saling mendukung. Kami percaya bahwa komunikasi tanpa batas dapat menciptakan hubungan yang lebih erat dan inklusif. Mari bersama membangun lingkungan yang lebih ramah dan suportif bagi semua!",
      "kategori": "Acara",
      "link": "https://whatsapp.com/channel/0029Van6EkM7j6gA3gwjVP0d",
    },
  ];

  final User? user = FirebaseAuth.instance.currentUser;
  String? displayName;
  File? profileImage;
  String? email;

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
        setState(() {
          displayName = data["username"] ?? "Pengguna"; // ambil dari Firestore
          phoneNumber = data["phone"] ?? "-";
          imageUrl = data["imageUrl"] ?? null;

          // kalau ada imageUrl, simpan URL
          if (data["imageUrl"] != null &&
              data["imageUrl"].toString().isNotEmpty) {
            // simpan URL untuk ditampilkan via NetworkImage
            // kalau lokal
            // atau lebih aman: simpan ke variabel String urlImage
          }
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
    // Filter kategori + search
    final List<Map<String, String>> dataTampil = komunitas.where((k) {
      final cocokKategori =
          kategoriAktif == "Semua" || k["kategori"] == kategoriAktif;
      final cocokCari =
          cari.isEmpty || k["nama"]!.toLowerCase().contains(cari.toLowerCase());
      return cocokKategori && cocokCari;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER + SEARCH BAR
            Stack(
              clipBehavior: Clip.none,
              children: [
                // HEADER BIRU
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  // padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5BC8FF),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                // top: MediaQuery.of(context).size.height * 0.05,
                                left: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WidgetProfil(),
                                    ),
                                  );
                                  if (updated == true) {
                                    _loadProfileData(); // refresh setelah edit
                                  }
                                },
                                child: GestureDetector(
                                  onTap: widget.onProfileTap,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        (imageUrl != null &&
                                            imageUrl!.isNotEmpty)
                                        ? NetworkImage(imageUrl!)
                                        : AssetImage(
                                                "assets/images/fotoProfil.png",
                                              )
                                              as ImageProvider,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.start, // <-- ini penting
                              children: [
                                Text(
                                  "Selamat Datang",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  displayName ?? user?.email ?? "Pengguna",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),

                            Spacer(),

                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.only(
                                    // top: MediaQuery.of(context).size.height * 0.05,
                                    left:
                                        MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  onPressed: () {},
                                  icon: Image.asset(
                                    "assets/Icon/NotifIcon.png",
                                    height:
                                        MediaQuery.of(context).size.height *
                                        (20 /
                                            MediaQuery.of(context).size.height),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    "assets/Icon/Settings.png",
                                    height:
                                        MediaQuery.of(context).size.height *
                                        (20 /
                                            MediaQuery.of(context).size.height),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            top: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Text(
                            "Ayo, Cari Komunitas dan Dapatkan\nBanyak Teman untuk Anda!",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // SEARCH BAR nempel di bawah header
                Positioned(
                  bottom: -20, // bikin nempel setengah keluar
                  left: 16,
                  right: 16,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() => cari = val);
                      },
                      decoration: InputDecoration(
                        hintText: "Cari komunitas...",
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.0130,
                          horizontal: MediaQuery.of(context).size.width * 0.015,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // KATEGORI TAB
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ["Semua", "Acara", "Webinar", "Promosi"].map((
                    kategori,
                  ) {
                    final aktif = kategoriAktif == kategori;
                    return GestureDetector(
                      onTap: () {
                        setState(() => kategoriAktif = kategori);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: const EdgeInsets.only(right: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: aktif ? const Color(0xFFEAF2FF) : Colors.white,
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // 👈 border radius disamain
                          border: Border.all(
                            color: aktif
                                ? const Color(0xFF3A80F7)
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          kategori,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: aktif
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: aktif
                                ? const Color(0xFF3A80F7)
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            // GRID KOMUNITAS
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: dataTampil.length,
                itemBuilder: (context, index) {
                  final item = dataTampil[index];
                  return komunitasCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kartu Komunitas
  Widget komunitasCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(158, 158, 158, 0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gambar + Avatar Bulet
          Stack(
            clipBehavior:
                Clip.none, // <-- biar avatar bisa keluar dari container
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  item["gambar"]!,
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -28, // biar avatar nongol keluar
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28,
                    backgroundImage: AssetImage(item["icon"]!),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ), // kasih space biar ga ketimpa teks
          // Nama & pengikut
          Text(
            item["nama"]!,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            item["pengikut"]!,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
          ),

          const Spacer(),

          // Tombol Ikuti
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKomunitasPage(
                      nama: item["nama"]!,
                      pengikut: item["pengikut"]!,
                      gambar: item["gambar"]!,
                      icon: item["icon"]!,
                      deskripsi: item["deskripsi"]!,
                      link: item["link"]!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A80F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                // shape: const StadiumBorder(), // <-- full pill shape
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.25,
                  MediaQuery.of(context).size.height * 0.035,
                ),

                // elevation: 0,
              ),
              child: Text(
                "Ikuti",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
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
