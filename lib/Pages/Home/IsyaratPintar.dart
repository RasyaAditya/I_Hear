  import 'package:flutter/material.dart';
import 'package:i_hear/Pages/Detail/DetailIsyarat.dart';
import '../../Widgets/WidgetCustom.dart';

class IsyaratPintar extends StatefulWidget {
  const IsyaratPintar({super.key});

  @override
  State<IsyaratPintar> createState() => _IsyaratPintarState();
}

class _IsyaratPintarState extends State<IsyaratPintar> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Data kategori
    final List<Map<String, dynamic>> kategori = [
      {
        "title": "Perkenalan",
        "subtitle": "15 Kata",
        "icon": "assets/Icon/Ls1.png",
        "page": const DetailIsyarat(),
      },
      {
        "title": "Transportasi",
        "subtitle": "19 Kata",
        "icon": "assets/Icon/Ls2.png",
        "page": null, // belum dibuat
      },
      {
        "title": "Kata Sapaan",
        "subtitle": "15 Kata",
        "icon": "assets/Icon/Ls3.png",
        "page": null, // belum dibuat
      },
      {
        "title": "Kata Bilangan",
        "subtitle": "15 Kata",
        "icon": "assets/Icon/Ls4.png",
        "page": null, // belum dibuat
      },
      {
        "title": "Kata Benda",
        "subtitle": "15 Kata",
        "icon": "assets/Icon/Ls5.png",
        "page": null, // belum dibuat
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: ListView.builder(
          itemCount: kategori.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: height * 0.02),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.04,
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Klik ${kategori[index]['title']}")),
                  );
                },
                child: Row(
                  children: [
                    // Kotak icon
                    Container(
                      width: width * 0.25,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        kategori[index]['icon'],
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: width * 0.04),

                    // Teks kategori + tombol kecil
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kategori[index]['title'],
                            style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            kategori[index]['subtitle'],
                            style: TextStyle(
                              fontSize: width * 0.035,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: height * 0.01),

                          // Tombol kecil "Mulai Belajar"
                          SizedBox(
                            height: height * 0.035,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final page = kategori[index]['page'];
                                if (page != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => page,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Page belum dibuat"),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Mulai Belajar",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
