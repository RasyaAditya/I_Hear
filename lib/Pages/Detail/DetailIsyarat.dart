import 'package:flutter/material.dart';
import 'package:i_hear/Widgets/WidgetCustom.dart';
import 'DetailVideo.dart';

class DetailIsyarat extends StatefulWidget {
  final Map<String, String> kataVideoMap;
  final String title;

  const DetailIsyarat({
    super.key,
    required this.kataVideoMap,
    required this.title,
  });

  @override
  State<DetailIsyarat> createState() => _DetailIsyaratState();
}

class _DetailIsyaratState extends State<DetailIsyarat> {
  late final List<String> kataList = widget.kataVideoMap.keys.toList();
  String query = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final filteredList = kataList
        .where((kata) => kata.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: CustomAppBar(titleText: widget.title),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: ListView.separated(
            itemCount: filteredList.length,
            separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1),
            itemBuilder: (context, index) {
              final kata = filteredList[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.02),
                title: Text(
                  kata,
                  style: TextStyle(fontSize: width * 0.045),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: width * 0.04),
                onTap: () {
                  final videoPath = widget.kataVideoMap[kata];
                  if (videoPath != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoDetailScreen(
                          kataList: kataList,
                          kataVideoMap: widget.kataVideoMap,
                          initialIndex: kataList.indexOf(kata),
                        
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Video untuk '$kata' belum tersedia",
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
