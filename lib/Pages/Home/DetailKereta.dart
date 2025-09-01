import 'package:flutter/material.dart';

class DetailPosisiKeretaPage extends StatefulWidget {
  @override
  _DetailPosisiKeretaPageState createState() => _DetailPosisiKeretaPageState();
}

class _DetailPosisiKeretaPageState extends State<DetailPosisiKeretaPage> {
  int selectedIndex = 0;

  final List<Map<String, String>> stations = [
    {"name": "JAKARTAKOTA", "time": "05:21"},
    {"name": "JAYAKARTA", "time": "05:25"},
    {"name": "MANGGA BESAR", "time": "05:27"},
    {"name": "SAWAH BESAR", "time": "05:28"},
    {"name": "JUANDA", "time": "05:29"},
    {"name": "GONDANGDIA", "time": "05:34"},
    {"name": "CIKINI", "time": "05:35"},
    {"name": "MANGGARAI", "time": "05:43"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // HEADER
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // biar balik ke halaman sebelumnya
                      },
                    ),
                    const Text(
                      "Detail Posisi Kereta",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // aksi notif
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              // LIST STASIUN
              Expanded(
                child: ListView.builder(
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    final isSelected = selectedIndex == index;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline
                        // Timeline
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                            left: 10,
                            top: 10,
                          ),
                          child: Column(
                            children: [
                              // Circle
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              // Garis nyambung ke circle bawah
                              if (index != stations.length - 1)
                                Container(
                                  width: 2,
                                  height: 50, // sesuaikan biar pas
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                        ),

                        // Chips
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ), // lebih kecil
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8, // lebih kecil
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.transparent,
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        station["name"]!,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10, // lebih kecil
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      station["time"]!,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          Positioned(
            top: 90,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.train, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          "Stasiun JAKARTAKOTA",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.place, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          "Stasiun BOGOR",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
