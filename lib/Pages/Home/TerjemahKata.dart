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
    "apa kabar": "assets/video/apaKabar.mp4",
    "aku": "assets/video/aku.mp4",
    "dia": "assets/video/dia.mp4",
    "kamu": "assets/video/kamu.mp4",
    "kita": "assets/video/kita.mp4",
    "tuli": "assets/video/tuli.mp4",
    "bahasa isyarat": "assets/video/BahasaIsyarat.mp4",
    "terima kasih": "assets/video/terimaKasih.mp4",
    "umur": "assets/video/umur.mp4",
    "sama sama": "assets/video/samaSama.mp4",
    "perkenalkan": "assets/video/perkenalkan.mp4",
    "kami": "assets/video/kami.mp4",
  };

  bool _showControls = false; // untuk tombol play/pause
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadVideo("assets/video/apaKabar.mp4");
    // Tidak load video / teks default
    // Tunggu user search
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

          // Search bar
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.height * 0.0005,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
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
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukan kata yang ingin anda cari...",
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
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
        _showControls = true; // tampilkan tombol play/pause saat ganti video
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
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _controller == null
            ? // Belum ada video → tampilkan background hitam + search bar
              Stack(
                children: [
                  // Top bar
                  Positioned(top: 8, left: 8, right: 8, child: _buildTopBar()),

                  // Bottom bar
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

                          // Top bar
                          Positioned(
                            top: 8,
                            left: 8,
                            right: 8,
                            child: _buildTopBar(),
                          ),

                          // Bottom bar
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
