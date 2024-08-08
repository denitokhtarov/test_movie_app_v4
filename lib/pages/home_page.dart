import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:themovie/pages/profile_pages/profile_page.dart';
import 'package:themovie/pages/feedPages/feed_page.dart';
import 'package:themovie/pages/filmsPages/films_page.dart';
import 'package:iconsax/iconsax.dart';
import 'package:themovie/pages/savedFilmsPages/saved_films_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const FeedPage(),
          const FilmPage(),
          SavedFilmsPage(
            () => setState(() {}),
          ),
          const ProfilePage()
        ],
      ),
      bottomNavigationBar: GNav(
        padding:
            const EdgeInsets.only(bottom: 40, top: 20, left: 25, right: 25),
        selectedIndex: _selectedIndex,
        onTabChange: onTabChange,
        color: const Color(0xFF7E7E7E),
        curve: Curves.easeInToLinear,
        activeColor: const Color.fromARGB(255, 189, 13, 0),
        backgroundColor: Colors.black,
        tabBorderRadius: 12,
        iconSize: 28,
        gap: 8,
        tabs: const [
          GButton(
            icon: Iconsax.home_24,
            text: 'Лента',
          ),
          GButton(
            icon: Iconsax.search_normal_14,
            text: 'Фильмы',
          ),
          GButton(
            icon: Iconsax.save_2,
            text: 'Избранное',
          ),
          GButton(
            icon: Iconsax.user,
            text: 'Профиль',
          ),
        ],
      ),
    );
  }
}
