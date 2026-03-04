import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/benefits_strip.dart';
import '../widgets/home/story_carousel.dart';
import '../widgets/home/popular_books_carousel.dart';
import '../widgets/home/memories_section.dart';
import '../widgets/home/format_card_carousel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const HeroSection(),
            const SizedBox(height: 0),
            const BenefitsStrip(),
            const SizedBox(height: AppSpacing.sectionGap),
            const StoryCarousel(),
            const SizedBox(height: AppSpacing.sectionGap),
            const PopularBooksCarousel(),
            const SizedBox(height: AppSpacing.sectionGap),
            const MemoriesSection(),
            const SizedBox(height: AppSpacing.sectionGap),
            const FormatCardCarousel(),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary2,
        backgroundColor: Colors.white,
        selectedFontSize: 8,
        unselectedFontSize: 8,
        iconSize: 24,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_outlined),
            activeIcon: Icon(Icons.collections),
            label: 'Коллекции',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Мои проекты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Аккаунт',
          ),
        ],
      ),
    );
  }
}
