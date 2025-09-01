import 'package:flutter/material.dart';
import 'package:i_hear/Widgets/WidgetCustom.dart';
import 'DetailVideo.dart';

class DetailIsyarat extends StatefulWidget {
  const DetailIsyarat({super.key});

  @override
  State<DetailIsyarat> createState() => _DetailIsyaratState();
}

class _DetailIsyaratState extends State<DetailIsyarat> {
  // mapping kata ke video
  final Map<String, String> kataVideoMap = {
    "Aku": "assets/video/aku.mp4",
    "Kamu": "assets/video/kamu.mp4",
    "Terima kasih": "assets/video/terimaKasih.mp4",
    "Apa kabar": "assets/video/apaKabar.mp4",
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

  // contoh data kata (ambil dari key mapping supaya konsisten)
  late final List<String> kataList = kataVideoMap.keys.toList();

  String query = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final filteredList = kataList
        .where((kata) => kata.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, // padding kiri-kanan responsif
          ),
          child: ListView.separated(
            itemCount: filteredList.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, thickness: 1), // Divider tetap ada
            itemBuilder: (context, index) {
              final kata = filteredList[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.02),
                title: Text(
                  kata,
                  style: TextStyle(
                    fontSize: width * 0.045, // font responsif
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: width * 0.04, // icon responsif
                ),
                onTap: () {
                  final videoPath = kataVideoMap[kata];
                  if (videoPath != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VideoDetailScreen(kata: kata, videoPath: videoPath),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Video untuk '$kata' belum tersedia",
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
