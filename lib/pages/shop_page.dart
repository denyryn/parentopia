import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopPage extends StatelessWidget {
  final List<Map<String, String>> productData;
  const ShopPage({Key? key, required this.productData}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size.width / 1.45;
    var mediaW = MediaQuery.of(context).size.width;
    
    double butText = 15;
    double butLogo = 25;
    
    return Scrollbar(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: false,
                elevation: 0,
                backgroundColor: Colors.white,
                expandedHeight: 100.0,
                flexibleSpace: Center(
                child: Center(
                  child: Text(
                      'Dapatkan kebutuhan si Kecil dari \netalase pilihan kami',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 17
                      ),
                    ),
                ),
                ),
                
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 10.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return FittedBox(
                          child: Container(
                            width: mediaW / 1.12,
                            // height: constraints.maxHeight,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                              border: Border.all(width: 3.0, color: const Color.fromARGB(115, 224, 224, 224)),
                              color: Colors.white70,
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: Image.network(
                                      productData[index]['imageURL'] as String,
                                      width: mediaW,
                                      height: constraints.maxWidth * (400 / mediaW),
                                      fit: BoxFit.cover,
                                    ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          productData[index]['name'] as String,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)
                                            )
                                          ),
                                          minimumSize: MaterialStateProperty.all(Size(
                                            media, // Adjust the multiplier as needed
                                            60,
                                          ),),
                                          backgroundColor:  MaterialStateProperty.all<Color>(const Color.fromRGBO(238, 77, 45, 1.0)),
                                        ),
                                        onPressed: () {
                                          launchUrl(Uri.parse(productData[index]['externalLinkShopee'] as String));
                                        },
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image.asset(
                                                "assets/logo/Shopee_Logo.png",
                                                width: butLogo,
                                                height: butLogo,
                                              ),
                                              const SizedBox(width: 5,),
                                              Text(
                                                "Beli di Shopee",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: butText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ),
                                      const SizedBox(height: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)
                                            )
                                          ),
                                          minimumSize: MaterialStateProperty.all(Size(
                                            media, 
                                            60,
                                          ),),
                                          backgroundColor:  MaterialStateProperty.all<Color>(const Color.fromRGBO(66, 181, 73, 1.0)),
                                        ),
                                        onPressed: () {
                                          launchUrl(Uri.parse(productData[index]['externalLinkTokopedia'] as String));
                                        },
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image.asset(
                                                "assets/logo/Tokopedia_Logo.png",
                                                width: butLogo,
                                                height: butLogo,
                                              ),
                                              const SizedBox(width: 5,),
                                              Text(
                                                "Beli di Tokopedia",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: butText,
                                                ),
                                              ),
                                              const SizedBox(height: 10,),
                                            ],
                                          ),
                                        )
                                      ),
                                      const SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: productData.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}