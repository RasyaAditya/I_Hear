import 'package:flutter/material.dart';
import '../../Widgets/WidgetHome.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../../Widgets/WidgetComunity.dart';
import '../../Widgets/WidgetProfil.dart';
import '../../Widgets/WidgetArtikel.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // List<Widget> widgets = [];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: currentIndex,
        items: <Widget>[
          Image.asset(
            'assets/Icon/HomeIcom.png',
            height:
                MediaQuery.of(context).size.height *
                (28 / MediaQuery.of(context).size.height),
          ),
          Image.asset(
            'assets/Icon/ComunityIconNew.png',
            height:
                MediaQuery.of(context).size.height *
                (28 / MediaQuery.of(context).size.height),
          ),
          Image.asset(
            'assets/Icon/ArtikelIcon.png',
            height:
                MediaQuery.of(context).size.height *
                (28 / MediaQuery.of(context).size.height),
          ),
          Image.asset(
            'assets/Icon/ProfilIcon.png',
            height:
                MediaQuery.of(context).size.height *
                (28 / MediaQuery.of(context).size.height),
          ),
        ],
        color: Color(0xff2F80ED),
        buttonBackgroundColor: Color(0xff2F80ED),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: Colors.white,
        child: [
          WidgetHome(
            onProfileTap: () {
              setState(() {
                currentIndex = 3; // index WidgetProfil
              });
            },
          ),
          WidgetComunity(),
          WidgetArtikel(),
          WidgetProfil(),
        ][currentIndex],
      ),
    );
  }
}
