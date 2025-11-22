import 'package:flutter/material.dart';
import 'package:i_hear/Pages/Detail/DetailIsyarat.dart';
import '../../Widgets/WidgetCustom.dart';

class IsyaratPintar extends StatefulWidget {
  const IsyaratPintar({super.key});

  @override
  State<IsyaratPintar> createState() => _IsyaratPintarState();
}

class _IsyaratPintarState extends State<IsyaratPintar> {
  // ===================== DATASET =====================

  // Perkenalan
  final Map<String, String> perkenalanMap = {
    "Aku": "assets/video/aku.mp4",
    "Kamu": "assets/video/kamu.mp4",
    "Terima kasih": "assets/video/terimakasih.mp4",
    "Apa kabar": "assets/video/apakabar.mp4",
    "Tuli": "assets/video/tuli.mp4",
    "Sama sama": "assets/video/samaSama.mp4",
    "Bahasa Isyarat": "assets/video/BahasaIsyarat.mp4",
    "Dengar": "assets/video/dengar.mp4",
    "Dia": "assets/video/dia.mp4",
    "Kami": "assets/video/kami.mp4",
    "Kita": "assets/video/kita.mp4",
    "Perkenalkan": "assets/video/perkenalkan.mp4",
    "Umur": "assets/video/umur.mp4",
  };

  // Transportasi
  final Map<String, String> transportasiMap = {
    "Transportasi": "assets/video/Transportasi.mp4",
    "Sepeda": "assets/video/Sepeda.mp4",
    "Perahu": "assets/video/Perahu.mp4",
    "Mobil": "assets/video/Mobil.mp4",
    "Motor": "assets/video/Motor.mp4",
    "Kendaraan": "assets/video/Kendaraan.mp4",
    "Kapal": "assets/video/Kapal.mp4",
    "Grabcar": "assets/video/Grabcar.mp4",
    "Grabike": "assets/video/Grabbike.mp4",
    "Grab": "assets/video/Grab.mp4",
    "Gocar": "assets/video/Gocar.mp4",
    "Bus": "assets/video/Bus.mp4",
    "Angkutan Umum": "assets/video/Angkutan umum.mp4",
    "Becak": "assets/video/Becak.mp4",
    "Truk": "assets/video/Truk.mp4",
    "Pesawat": "assets/video/Pesawat.mp4",
    "Kereta Api": "assets/video/Keretaapi.mp4",
  };

  // Alfabet
  final Map<String, String> alfabetMap = {
    "A": "assets/video/A.mp4",
    "B": "assets/video/B.mp4",
    "C": "assets/video/C.mp4",
    "D": "assets/video/D.mp4",
    "E": "assets/video/E.mp4",
    "F": "assets/video/F.mp4",
    "G": "assets/video/G.mp4",
    "H": "assets/video/H.mp4",
    "I": "assets/video/I.mp4",
    "J": "assets/video/J.mp4",
    "K": "assets/video/K.mp4",
    "L": "assets/video/L.mp4",
    "M": "assets/video/M.mp4",
    "N": "assets/video/N.mp4",
    "O": "assets/video/O.mp4",
    "P": "assets/video/P.mp4",
    "Q": "assets/video/Q.mp4",
    "R": "assets/video/R.mp4",
    "S": "assets/video/S.mp4",
    "T": "assets/video/T.mp4",
    "U": "assets/video/U.mp4",
    "V": "assets/video/V.mp4",
    "W": "assets/video/W.mp4",
    "X": "assets/video/X.mp4",
    "Y": "assets/video/Y.mp4",
    "Z": "assets/video/Z.mp4",
  };

  // Bilangan
  final Map<String, String> bilanganMap = {
    "Satu": "assets/video/1.mp4",
    "Dua": "assets/video/2.mp4",
    "Tiga": "assets/video/3.mp4",
    "Empat": "assets/video/4.mp4",
    "Lima": "assets/video/5.mp4",
    "Enam": "assets/video/6.mp4",
    "Tujuh": "assets/video/7.mp4",
    "Delapan": "assets/video/8.mp4", // pastikan ada di assets
    "Sembilan": "assets/video/9.mp4",
    "Sepuluh": "assets/video/10.mp4",
  };
  final Map<String, String> emosionalmap = {
    "Kaget": "assets/video/Kaget.mp4",
    "Kecewa": "assets/video/Kecewa.mp4",
    "Kesal": "assets/video/Kesal.mp4",
    "Malu": "assets/video/Malu.mp4",
    "Marah": "assets/video/Marah.mp4",
    "Menyakitkan": "assets/video/Menyakitkan.mp4",
    "Sedih": "assets/video/Sedih.mp4",
    "Senang": "assets/video/Senang.mp4", // pastikan ada di assets
    "Takut": "assets/video/Takut.mp4",
    "Tersinggung": "assets/video/Tersinggung.mp4",
  };
  final Map<String, String> sapaanmap = {
    "Halo": "assets/video/Halo.mp4",
    "Sampai Jumpa": "assets/video/Sampai-jumpa.mp4",
    "Sampai Ketemu Lagi": "assets/video/Sampai-ketemu-lagi.mp4",
    "Selamat Malam": "assets/video/Selamat-malam.mp4",
    "Selamat Pagi": "assets/video/Selamat-pagi.mp4",
    "Selamat Siang": "assets/video/Selamat-siang.mp4",
    "Selamat Sore": "assets/video/Selamat-sore.mp4",
    "Selamat Tinggal":
        "assets/video/Selamat-tinggal.mp4", // pastikan ada di assets
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> kategori = [
      {
        "title": "Perkenalan",
        "subtitle": "13 Kata",
        "icon": "assets/Icon/Ls1.png",
        "bg": "assets/images/IP9.png",
        "page": DetailIsyarat(kataVideoMap: perkenalanMap, title: "Perkenalan"),
      },
      {
        "title": "Transportasi",
        "subtitle": "17 Kata",
        "icon": "assets/Icon/Ls2.png",
        "bg": "assets/images/IP11.png",
        "page": DetailIsyarat(
          kataVideoMap: transportasiMap,
          title: "Transportasi",
        ),
      },
      {
        "title": "Alfabet",
        "subtitle": "26 Kata",
        "icon": "assets/Icon/Ls6.png",
        "bg": "assets/images/IP12.png",
        "page": DetailIsyarat(kataVideoMap: alfabetMap, title: "Alfabet"),
      },
      {
        "title": "Bilangan",
        "subtitle": "10 Kata",
        "icon": "assets/Icon/Ls4.png",
        "bg": "assets/images/IP8.png",
        "page": DetailIsyarat(kataVideoMap: bilanganMap, title: "Bilangan"),
      },
      {
        "title": "Emosional",
        "subtitle": "10 Kata",
        "icon": "assets/Icon/Ls7.png",
        "bg": "assets/images/IP7.png",
        "page": DetailIsyarat(kataVideoMap: emosionalmap, title: "Emosional"),
      },
      {
        "title": "Sapaan",
        "subtitle": "8 Kata",
        "icon": "assets/Icon/Ls3.png",
        "bg": "assets/images/IP10.png",
        "page": DetailIsyarat(kataVideoMap: sapaanmap, title: "Sapaan"),
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: GridView.builder(
          itemCount: kategori.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: width * 0.04,
            mainAxisSpacing: height * 0.02,
            childAspectRatio: 0.66,
          ),
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Column(
                children: [
                  // Bagian gambar + icon bulat
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Background foto
                      Container(
                        height: height * 0.12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          image: DecorationImage(
                            image: AssetImage(kategori[index]['bg']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Icon bulat
                      Positioned(
                        bottom: -height * 0.04,
                        child: CircleAvatar(
                          radius: height * 0.045,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            kategori[index]['icon'],
                            fit: BoxFit.contain,
                            height: height * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.05),
                  Text(
                    kategori[index]['title'],
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    kategori[index]['subtitle'],
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.01),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A80F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: Size(width * 0.25, height * 0.04),
                      ),
                      onPressed: () {
                        final page = kategori[index]['page'];
                        if (page != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => page),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Page belum dibuat")),
                          );
                        }
                      },
                      child: const Text(
                        "Mulai Belajar",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
