import 'package:flutter/cupertino.dart';
import 'package:parentopia/bloc/bottom_nav_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/pages.dart';
import '../repository/repositories.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late PageController pageController;
  late HomeRepository homeRepository;

  var color = const Color.fromARGB(246, 126, 180, 250);

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    homeRepository = HomeRepository();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// on Page Changed
  void onPageChanged(int page) {
    BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      // appBar: _mainWrapperAppBar(),
      body: _mainWrapperBody(),
      bottomNavigationBar: _mainWrapperBottomNavBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _mainWrapperFab(),
    );
  }

  // Bottom Navigation Bar - MainWrapper Widget
  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    return BottomAppBar(
      height: 60,
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bottomAppBarItem(
                      context,
                      defaultIcon: IconlyLight.home,
                      page: 0,
                      label: "Home",
                      filledIcon: IconlyBold.home,
                    ),
                    _bottomAppBarItem(
                      context,
                      defaultIcon: IconlyLight.discovery,
                      page: 1,
                      label: "Notifs",
                      filledIcon: IconlyBold.discovery,
                    ),
                    _bottomAppBarItem(
                      context,
                      defaultIcon: IconlyLight.bag,
                      page: 2,
                      label: "Profile",
                      filledIcon: IconlyBold.bag,
                    ),
                    _bottomAppBarItem(
                      context,
                      defaultIcon: IconlyLight.profile,
                      page: 3,
                      label: "Profile",
                      filledIcon: IconlyBold.profile,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Floating Action Button - MainWrapper Widget
  FloatingActionButton _mainWrapperFab() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotePage()),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      backgroundColor: color,
      child: const Icon(
        IconlyBold.document,
        color: Colors.white,
      ),
    );
  }

  // Body - MainWrapper Widget
  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: [
        // Pass carouselData to HomePage
        _buildHomePage(),
        _buildDiscoverPage(),
        _buildShopPage(),
        const ProfilePage(),
      ],
    );
  }

  // Bottom Navigation Bar Single item - MainWrapper Widget
  Widget _bottomAppBarItem(
    BuildContext context, {
    required defaultIcon,
    required page,
    required label,
    required filledIcon,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);

        pageController.animateToPage(page,
            duration: const Duration(milliseconds: 10),
            curve: Curves.fastLinearToSlowEaseIn);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 5,
            ),
            Icon(
              context.watch<BottomNavCubit>().state == page
                  ? filledIcon
                  : defaultIcon,
              color: context.watch<BottomNavCubit>().state == page
                  ? color
                  : Colors.grey,
              size: 26,
            ),
            const SizedBox(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build HomePage
  Widget _buildHomePage() {
    final homeRepo = HomeRepository();

    return FutureBuilder<List<List<Map<String, String>>>>(
      future: Future.wait([homeRepo.fetchCarouselData(),homeRepo.fetchClassesData(), homeRepo.fetchPopularArticleData()]),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 3, 155, 229),));
        } else if (snapshots.hasError) {
          return Center(child: Text('Error: ${snapshots.error}'));
        } else {
          List<Map<String, String>> carouselData = snapshots.data![0];
          List<Map<String, String>> popularArticleData = snapshots.data![2];
          List<Map<String, String>> classesData = snapshots.data![1];

          if (carouselData.isEmpty && popularArticleData.isEmpty && classesData.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: Colors.grey.shade600,
                  size: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Terdapat Error Pada Jaringan \natau Sistem Kami',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Kami akan memperbaiki segera. Sementara, cek koneksi internet anda",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          } else {
            // Both carouselData and popularArticleData are available, build HomePage
            return HomePage(
              carouselData: carouselData,
              classesData: classesData,
              popularArticleData: popularArticleData,
            );
          }
        }
      },
    );
  }


  Widget _buildShopPage() {
    final productsRepo = ProductsRepository(); // Create an instance of your repository

    return FutureBuilder<List<Map<String, String>>>(
      future: productsRepo.fetchProductData(), // Call the fetchProductData method
      builder: (context, productSnapshot) {
        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 3, 155, 229),));
        } else if (productSnapshot.hasError) {
          return Center(child: Text('Error: ${productSnapshot.error}'));
        } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.cube_box,
                color: Colors.grey.shade600,
                size: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Tidak ada Produk yang Tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Kami akan menambahkan produk segera.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        } else {
          // Pass product data to ShopPage
          return ShopPage(productData: productSnapshot.data!);
        }
      },
    );
  }


  Widget _buildDiscoverPage() {
    final articlesRepo = ArticlesRepository(); // Create an instance of your repository

    return FutureBuilder<List<Map<String, String>>>(
      future: articlesRepo.fetchArticleData(), // Call the fetchArticleData method
      builder: (context, articleSnapshot) {
        if (articleSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 3, 155, 229),));
        } else if (articleSnapshot.hasError) {
          return Center(child: Text('Error: ${articleSnapshot.error}'));
        } else if (!articleSnapshot.hasData || articleSnapshot.data!.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.cube_box,
                color: Colors.grey.shade600,
                size: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Tidak ada Artikel yang Tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Kami akan menambahkan Artikel segera.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        } else {
          // Pass product data to ShopPage
          return DiscoverPage(articleData: articleSnapshot.data!);
        }
      },
    );
  }
}
