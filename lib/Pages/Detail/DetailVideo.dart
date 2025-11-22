import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  final List<String> kataList;
  final Map<String, String> kataVideoMap;
  final int initialIndex;

  const VideoDetailScreen({
    super.key,
    required this.kataList,
    required this.kataVideoMap,
    required this.initialIndex,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  late int currentIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentIndex = widget.initialIndex;
    _loadVideo();
  }

  void _loadVideo() {
    final kata = widget.kataList[currentIndex];
    final videoPath = widget.kataVideoMap[kata]!;

    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
  }

  void _changeVideo(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.kataList.length) return;

    setState(() {
      currentIndex = newIndex;
    });

    _controller.pause();
    _controller.dispose();
    _loadVideo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller.pause();
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final kata = widget.kataList[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔥 Video full layar
          Center(
            child: _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ),

          // 🔥 Tap layar = play/pause
          GestureDetector(
            onTap: _togglePlayPause,
            child: Center(
              child: AnimatedOpacity(
                opacity: _isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                  size: width * 0.2,
                ),
              ),
            ),
          ),

          // 🔙 Tombol back keluar
          Positioned(
            top: height * 0.05,
            left: width * 0.04,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: width * 0.08,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 🔹 Info + tombol Next/Prev ( sejajar tulisan )
          Positioned(
            bottom: height * 0.08, // dinaikin dikit
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔙 tombol back bulat
                if (currentIndex > 0)
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: width * 0.07,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: width * 0.05,
                        ),
                        onPressed: () => _changeVideo(currentIndex - 1),
                      ),
                    ),
                  )
                else
                  SizedBox(width: width * 0.15),

                // 🔹 teks di tengah
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '"$kata"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.06,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.005),
                      Text(
                        "Perkenalan - BISINDO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // 👉 tombol next bulat
                if (currentIndex < widget.kataList.length - 1)
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: width * 0.07,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: width * 0.05,
                        ),
                        onPressed: () => _changeVideo(currentIndex + 1),
                      ),
                    ),
                  )
                else
                  SizedBox(width: width * 0.15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
