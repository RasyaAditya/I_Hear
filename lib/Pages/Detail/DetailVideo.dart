import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  final String kata;
  final String videoPath;

  const VideoDetailScreen({
    super.key,
    required this.kata,
    required this.videoPath,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        _controller.setLooping(true); // looping terus
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
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
    final size = MediaQuery.of(context).size; // untuk responsif
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔥 video full layar
          Center(
            child: _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover, // biar bener2 penuh
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ),

          // Tombol play/pause di tengah
          GestureDetector(
            onTap: _togglePlayPause,
            child: Center(
              child: AnimatedOpacity(
                opacity: _isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                  size: width * 0.2, // responsif icon play/pause
                ),
              ),
            ),
          ),

          // Tombol back
          Positioned(
            top: height * 0.05,
            left: width * 0.04,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: width * 0.08, // responsif ukuran tombol back
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Bottom info (judul + BISINDO)
          Positioned(
            bottom: height * 0.06,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.kata}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.06, // responsif font
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  "BISINDO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.045, // responsif font BISINDO
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
