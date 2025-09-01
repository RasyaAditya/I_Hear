import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; // ✅ Tambahin ini

class BasicBA extends StatefulWidget {
  const BasicBA({super.key});

  @override
  State<BasicBA> createState() => _BasicBAState();
}

class _BasicBAState extends State<BasicBA> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  double _turns = 0;
  bool _hasText = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isRotated = false;

  void _listen() async {
    // ✅ Cek permission mic dulu
    var status = await Permission.microphone.request();

    if (status.isGranted) {
      if (!_isListening) {
        bool available = await _speech.initialize(
          onStatus: (val) => print('Status: $val'),
          onError: (val) => print('Error: $val'),
        );

        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) {
              // langsung update ke textfield
              _controller.value = TextEditingValue(
                text: val.recognizedWords,
                selection: TextSelection.collapsed(
                  offset: val.recognizedWords.length,
                ),
              );

              setState(() {
                _hasText = val.recognizedWords.isNotEmpty;
              });

              // otomatis kirim kalau final
              if (val.finalResult && val.recognizedWords.isNotEmpty) {
                _sendMessage();
              }
            },
          );
        }
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    } else {
      print("❌ Mic permission ditolak user");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });

    _speech = stt.SpeechToText();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
        _hasText = false;
      });
    }
  }

  void _rotateScreen() {
    setState(() {
      _isRotated = !_isRotated;
      _turns = _isRotated ? 0.5 : 0.0;
    });

    if (_isRotated) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedRotation(
      turns: _turns,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Suara Tulis",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.black),
            ),
          ],
        ),
        body: Column(
          children: [
            // ===== CHAT LIST =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F80ED),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _messages[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ===== INPUT BAR =====
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Textfield box
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (value) {
                                setState(() {
                                  _hasText = value.isNotEmpty;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "Masukan kalimat kamu!",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _messages.clear();
                              });
                            },
                            icon: const Icon(Icons.delete, color: Colors.grey),
                          ),
                          IconButton(
                            onPressed: _rotateScreen,
                            icon: const Icon(
                              Icons.people_alt_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ===== MIC / SEND BUTTON =====
                  GestureDetector(
                    onTap: _hasText ? _sendMessage : _listen,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(screenWidth * 0.035),
                      decoration: BoxDecoration(
                        color: _isListening
                            ? Colors.red
                            : const Color(0xFF2F80ED),
                        shape: BoxShape.circle,
                        boxShadow: _isListening
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.6),
                                  blurRadius: 18,
                                  spreadRadius: 4,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        _hasText
                            ? Icons.send
                            : (_isListening ? Icons.mic : Icons.mic_none),
                        color: Colors.white,
                        size: screenWidth * 0.06,
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
  }
}
