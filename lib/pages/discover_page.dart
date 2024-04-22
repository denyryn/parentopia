import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscoverPage extends StatelessWidget {
  final List<Map<String, String>> articleData;

  const DiscoverPage({Key? key, required this.articleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: false,
          elevation: 0,
          backgroundColor: Colors.white,
          expandedHeight: 100.0,
          flexibleSpace: Center(
            child: Text(
                  "Ayo Lihat Artikel Menarik\n Pilihan Kami",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                  ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                            Uri imageUri = Uri.parse(articleData[index]['externalLink']!);
                            launchUrl(imageUri);
                          },
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 160,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        articleData[index]['imageURL']!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,)
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: articleData.length,
            ),
          ),
        ),
      ],
    );
  }
}
