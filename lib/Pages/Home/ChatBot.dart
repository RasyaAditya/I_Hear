import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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
  File? profileImage;

  ChatUser? currentChatUser;
  late ChatUser bot;

  List<ChatMessage> messages = [];
  late GenerativeModel model;
  late ChatSession chat;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _initGemini();
  }

  void _loadProfileData() {
    final box = GetStorage();
    final email = firebaseUser?.email ?? "";
    final data = box.read("Data_$email");

    String finalName;
    String? finalImage;

    if (data != null) {
      finalName = data["DisplayName"] ?? "Pengguna";
      if (data["Image"] != null) {
        finalImage = File(data["Image"]).path;
      }
    } else {
      finalName = firebaseUser?.email ?? "Pengguna";
      finalImage = null;
    }

    setState(() {
      displayName = finalName;
      profileImage = finalImage != null ? File(finalImage) : null;

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
    });
  }

  void _initGemini() {
    const apiKey = "AIzaSyCqljg_5KnIN5ePU4EDBoj52hWwdlgVygo";
    model = GenerativeModel(model: "gemini-1.5-flash", apiKey: apiKey);
    chat = model.startChat();
  }

  Future<void> sendMessage(ChatMessage m) async {
    setState(() {
      messages.insert(0, m);
    });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: Text(
          "Chat Bot",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
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
          : DashChat(
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

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // Nama user tepat di atas bubble
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 2,
                              ), // biar rapat ke bubble
                              child: Text(
                                message.user.firstName ?? "",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrentUser
                                      ? Colors.blue
                                      : Colors.black87,
                                ),
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: isCurrentUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isCurrentUser) ...[
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.lightBlue,
                                    backgroundImage: AssetImage(
                                      "assets/Icon/bot.png",
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser
                                          ? const Color(0xff2F80ED)
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: isCurrentUser
                                            ? const Radius.circular(16)
                                            : const Radius.circular(4),
                                        bottomRight: isCurrentUser
                                            ? const Radius.circular(4)
                                            : const Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      message.text,
                                      style: GoogleFonts.poppins(
                                        color: isCurrentUser
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isCurrentUser) ...[
                                  const SizedBox(width: 6),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: profileImage != null
                                        ? FileImage(profileImage!)
                                        : const AssetImage(
                                                "assets/default_avatar.png",
                                              )
                                              as ImageProvider,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
              ),
              inputOptions: InputOptions(
                inputDecoration: InputDecoration(
                  hintText: "Apakah yang ingin saya bantu?",
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                sendButtonBuilder: (onSend) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xff4AC2FF), Color(0xff2F80ED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: onSend,
                  ),
                ),
              ),
            ),
    );
  }
}
