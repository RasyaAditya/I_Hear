import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:i_hear/Pages/Home/HomePage.dart';
import 'package:i_hear/Pages/Home/Opening.dart';
import 'package:i_hear/Pages/Home/SplashScreen.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  Widget mainView = SplashScreen();

  if (FirebaseAuth.instance.currentUser != null) {
    mainView = HomePage();
  }
  runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: mainView));
}
