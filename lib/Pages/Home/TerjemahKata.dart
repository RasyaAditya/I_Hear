import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideo;

  final TextEditingController _searchController = TextEditingController();
  String? _searchedWord;

  final Map<String, String> _videoMap = {
    "apa kabar": "assets/video/apakabar.mp4",
    "aku": "assets/video/aku.mp4",
    "dia": "assets/video/dia.mp4",
    "kamu": "assets/video/kamu.mp4",
    "kita": "assets/video/kita.mp4",
    "tuli": "assets/video/tuli.mp4",
    "bahasa isyarat": "assets/video/BahasaIsyarat.mp4",
    "terima kasih": "assets/video/terimakasih.mp4",
    "umur": "assets/video/umur.mp4",
    "sama sama": "assets/video/samaSama.mp4",
    "perkenalkan": "assets/video/perkenalkan.mp4",
    "kami": "assets/video/kami.mp4",
    "satu": "assets/video/1.mp4",
    "dua": "assets/video/2.mp4",
    "tiga": "assets/video/3.mp4",
    "empat": "assets/video/4.mp4",
    "lima": "assets/video/5.mp4",
    "enam": "assets/video/6.mp4",
    "tujuh": "assets/video/7.mp4",
    "delapan": "assets/video/8.mp4",
    "sembilan": "assets/video/9.mp4",
    "sepuluh": "assets/video/10.mp4",
    "kaget": "assets/video/kaget.mp4",
    "kecewa": "assets/video/kecewa.mp4",
    "kesal": "assets/video/kesal.mp4",
    "malu": "assets/video/malu.mp4",
    "marah": "assets/video/marah.mp4",
    "menyakitkan": "assets/video/menyakitkan.mp4",
    "sedih": "assets/video/sedih.mp4",
    "senang": "assets/video/senang.mp4",
    "takut": "assets/video/takut.mp4",
    "tersinggung": "assets/video/tersinggung.mp4",
    "halo": "assets/video/halo.mp4",
    "sampai jumpa": "assets/video/sampai-jumpa.mp4",
    "sampai ketemu lagi": "assets/video/sampai-ketemu-lagi.mp4",
    "selamat malam": "assets/video/selamat-malam.mp4",
    "selamat pagi": "assets/video/selamat-pagi.mp4",
    "selamat siang": "assets/video/selamat-siang.mp4",
    "selamat sore": "assets/video/selamat-sore.mp4",
    "selamat tinggal": "assets/video/selamat-tinggal.mp4",
    "transportasi": "assets/video/Transportasi.mp4",
    "sepeda": "assets/video/Sepeda.mp4",
    "perahu": "assets/video/Perahu.mp4",
    "mobil": "assets/video/Mobil.mp4",
    "motor": "assets/video/Motor.mp4",
    "kendaraan": "assets/video/Kendaraan.mp4",
    "kapal": "assets/video/Kapal.mp4",
    "grabcar": "assets/video/Grabcar.mp4",
    "grabbike": "assets/video/Grabbike.mp4",
    "grab": "assets/video/Grab.mp4",
    "gocar": "assets/video/Gocar.mp4",
    "bus": "assets/video/Bus.mp4",
    "angkutan umum": "assets/video/Angkutan umum.mp4",
    "becak": "assets/video/Becak.mp4",
    "truk": "assets/video/Truk.mp4",
    "pesawat": "assets/video/Pesawat.mp4",
    "kereta api": "assets/video/Keretaapi.mp4",
    "a": "assets/video/A.mp4",
    "b": "assets/video/B.mp4",
    "c": "assets/video/C.mp4",
    "d": "assets/video/D.mp4",
    "e": "assets/video/E.mp4",
    "f": "assets/video/F.mp4",
    "g": "assets/video/G.mp4",
    "h": "assets/video/H.mp4",
    "i": "assets/video/I.mp4",
    "j": "assets/video/J.mp4",
    "k": "assets/video/K.mp4",
    "l": "assets/video/L.mp4",
    "m": "assets/video/M.mp4",
    "n": "assets/video/N.mp4",
    "o": "assets/video/O.mp4",
    "p": "assets/video/P.mp4",
    "q": "assets/video/Q.mp4",
    "r": "assets/video/R.mp4",
    "s": "assets/video/S.mp4",
    "t": "assets/video/T.mp4",
    "u": "assets/video/U.mp4",
    "v": "assets/video/V.mp4",
    "w": "assets/video/W.mp4",
    "x": "assets/video/X.mp4",
    "y": "assets/video/Y.mp4",
    "z": "assets/video/Z.mp4",
  };

  bool _showControls = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadVideo("assets/video/BahasaIsyarat.mp4");
  }

  void _loadVideo(String path) {
    _controller = VideoPlayerController.asset(path);
    _initializeVideo = _controller!.initialize().then((_) {
      _controller!.setLooping(true);
      setState(() {});
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _searchController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller?.pause();
    }
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_searchedWord != null) ...[
            Text(
              '"$_searchedWord"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Pencarian - BISINDO",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
          ],

          // Search bar rapi
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey("searchField"),
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukan kata yang ingin anda cari...",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _onSearch,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    if (_videoMap.containsKey(query)) {
      _controller?.pause();
      _controller?.dispose();

      _loadVideo(_videoMap[query]!);
      setState(() {
        _searchedWord = _capitalize(query);
        _showControls = true;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Video tidak ditemukan")));
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s
        .split(" ")
        .map(
          (word) =>
              word.isEmpty ? "" : word[0].toUpperCase() + word.substring(1),
        )
        .join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _controller == null
            ? Stack(
                children: [
                  Positioned(top: 8, left: 8, right: 8, child: _buildTopBar()),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildBottomBar(),
                  ),
                ],
              )
            : FutureBuilder(
                future: _initializeVideo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTap: _toggleControls,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controller!.value.size.width,
                                height: _controller!.value.size.height,
                                child: VideoPlayer(_controller!),
                              ),
                            ),
                          ),

                          // Tombol Play / Pause
                          if (_showControls)
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
                                  });
                                  _startHideTimer();
                                },
                                child: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  size: 70,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),

                          Positioned(
                            top: 8,
                            left: 8,
                            right: 8,
                            child: _buildTopBar(),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildBottomBar(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
    );
  }
}
