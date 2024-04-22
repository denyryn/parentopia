// home_page.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> carouselData;
  final List<Map<String, String>> classesData;
  final List<Map<String, String>> popularArticleData;

  const HomePage({Key? key, required this.carouselData, required this.classesData, required this.popularArticleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          pinned: false, // Set to false to make it non-sticky
          expandedHeight: 15.0, // Set the height of the app bar
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hallo, Parent',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
              // Icon(
              //   Icons.notifications_none_outlined,
              //   color: Colors.black,
              // ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: carouselData.length,
                    options: CarouselOptions(
                      height: 170.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 1,
                    ),
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return GestureDetector(
                        onTap: () {
                          Uri imageUri = Uri.parse(carouselData[index]['externalLink']!);
                          launchUrl(imageUri);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              carouselData[index]['imageUrl']!,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Text(
                    "Rekomendasi Kelas",
                    style: GoogleFonts.poppins(
                      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: classesData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Uri classUri = Uri.parse(classesData[index]['externalLink']!);
                            launchUrl(classUri);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
                            width: 130,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                  classesData[index]['imageUrl']!,
                                ), 
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    "Artikel Populer",
                    style: GoogleFonts.poppins(
                      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: popularArticleData.length,
                    shrinkWrap: true, // Add this line
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Uri imageUri = Uri.parse(popularArticleData[index]['externalLink']!);
                          launchUrl(imageUri);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(
                                popularArticleData[index]['imageUrl']!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
