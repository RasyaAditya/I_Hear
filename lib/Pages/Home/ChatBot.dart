import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_ai/firebase_ai.dart'; // UBAH IMPORT INI
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:i_hear/Pages/Home/HomePage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  String? displayName;
  String? imageUrl;
  String? finalName;
  String? finalImage;

  ChatUser? currentChatUser;
  late ChatUser bot;

  List<ChatMessage> messages = [];
  late GenerativeModel model;
  late ChatSession chat;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _initFirebaseAI(); // UBAH PEMANGGILAN METHOD
  }

  void _loadProfileData() async {
    final uid = firebaseUser?.uid;
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
          imageUrl = data["imageUrl"] ?? null;

          currentChatUser = ChatUser(
            id: firebaseUser?.uid ?? "1",
            firstName: finalName,
            profileImage: finalImage != null ? "file://$finalImage" : null,
          );

          bot = ChatUser(
            id: "2",
            firstName: "Sapa.AI",
            profileImage: "https://img.icons8.com/3d-fluency/94/bot.png",
          );

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
          displayName = firebaseUser?.email ?? "Pengguna";
        });
      }
    } catch (e) {
      print("Error load profile: $e");
    }
  }

  // GANTI METHOD INI
  void _initFirebaseAI() {
    // Tidak perlu API Key, karena sudah terhubung dengan project Firebase Anda
    model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash', // Nama model yang umum untuk Vertex AI
      // Anda bisa menambahkan safety settings di sini jika perlu
      // safetySettings: [
      //   SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      // ],
    );
    chat = model.startChat();
  }

  Future<void> sendMessage(ChatMessage m) async {
    setState(() {
      messages.insert(0, m);
    });

    try {
      // Baris ini tidak perlu diubah karena API-nya sama
      final response = await chat.sendMessage(Content.text(m.text));
      final reply = response.text ?? "Maaf, saya tidak bisa menjawab.";

      final botMessage = ChatMessage(
        user: bot,
        createdAt: DateTime.now(),
        text: reply,
      );

      setState(() {
        messages.insert(0, botMessage);
      });
    } catch (e) {
      final errorMessage = ChatMessage(
        user: bot,
        createdAt: DateTime.now(),
        text: "Maaf, terjadi kesalahan. Coba lagi nanti.",
      );
      setState(() {
        messages.insert(0, errorMessage);
      });
    }

    FocusScope.of(context).unfocus();
  }

  // --- TIDAK ADA PERUBAHAN PADA KODE UI DI BAWAH INI ---

  Widget _buildEmptyChatView(double screenWidth, double screenHeight) {
    // ... kode UI tidak berubah ...
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Icon/botbiru.png", height: screenHeight * 0.15),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Sapa Bot",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: const Color(0xff2F80ED),
              ),
            ),
            Text(
              "Teman Virtual Kamu",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              "Jalani Hari-harimu bersama Sapa Bot.\nJadikan Sapa Bot teman bermainmu!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomMessageRow(
    ChatMessage message,
    bool isCurrentUser,
    double screenWidth,
    double screenHeight,
  ) {
    // ... kode UI tidak berubah ...
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.007,
        horizontal: screenWidth * 0.02,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: screenWidth * 0.05,
              backgroundColor: Colors.grey[300],
              backgroundImage: const AssetImage("assets/Icon/AR.png"),
            ),
            SizedBox(width: screenWidth * 0.02),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.user.firstName ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                        color: isCurrentUser ? Colors.blue : Colors.black87,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      SizedBox(width: screenWidth * 0.02),
                      CircleAvatar(
                        radius: screenWidth * 0.05,
                        backgroundImage:
                            (imageUrl != null && imageUrl!.isNotEmpty)
                            ? NetworkImage(imageUrl!)
                            : const AssetImage("assets/images/fotoProfil.png")
                                  as ImageProvider,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? const Color(0xff2F80ED)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  child: MarkdownBody(
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.038,
                        color: isCurrentUser ? Colors.white : Colors.black,
                      ),
                      strong: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.bold,
                        color: isCurrentUser ? Colors.white : Colors.black,
                      ),
                      em: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.038,
                        fontStyle: FontStyle.italic,
                        color: isCurrentUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... kode UI tidak berubah ...
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: Text(
          "Chat Bot",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(HomePage()),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4AC2FF), Color(0xff2F80ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: currentChatUser == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      if (messages.isEmpty)
                        _buildEmptyChatView(screenWidth, screenHeight),
                      DashChat(
                        currentUser: currentChatUser!,
                        onSend: sendMessage,
                        messages: messages,
                        messageOptions: MessageOptions(
                          showCurrentUserAvatar: false,
                          showOtherUsersAvatar: false,
                          messageRowBuilder:
                              (
                                ChatMessage message,
                                ChatMessage? previous,
                                ChatMessage? next,
                                bool isAfterDateSeparator,
                                bool isBeforeDateSeparator,
                              ) {
                                bool isCurrentUser =
                                    message.user.id == currentChatUser!.id;
                                return _buildCustomMessageRow(
                                  message,
                                  isCurrentUser,
                                  screenWidth,
                                  screenHeight,
                                );
                              },
                        ),
                        inputOptions: InputOptions(
                          inputToolbarStyle: BoxDecoration(
                            color: const Color(0xffF5F7FA),
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                          ),
                          inputDecoration: InputDecoration(
                            hintText: messages.isEmpty
                                ? "Apakah ada sesuatu yang Anda ingin saya bantu?"
                                : "Ketik pesan...",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.030,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.075,
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          sendButtonBuilder: (onSend) => Container(
                            margin: EdgeInsets.only(
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.01,
                            ),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xff4AC2FF), Color(0xff2F80ED)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              ),
                              onPressed: onSend,
                            ),
                          ),
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
