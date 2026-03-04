import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingSlide {
  final String image;
  final String title;
  final String description;

  OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingSlide slide;

  const OnboardingSlideWidget({
    Key? key,
    required this.slide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Слой 1: Изображение на весь экран
        Positioned.fill(
          child: Image.asset(
            slide.image,
            fit: BoxFit.cover,
          ),
        ),
        // Слой 2: Легкий градиент затемнения снизу
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
                stops: [0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      image: 'assets/images/onboarding/slide_1.png',
      title: 'Сохраняй эмоции',
      description: 'Каждое фото хранит особенный момент вашей жизни',
    ),
    OnboardingSlide(
      image: 'assets/images/onboarding/slide_2.png',
      title: 'Дари близким',
      description: 'Лучший подарок — книга воспоминаний, созданная с любовью',
    ),
    OnboardingSlide(
      image: 'assets/images/onboarding/slide_3.png',
      title: 'Печатай воспоминания',
      description: 'Превратите цифровые фото в настоящую книгу',
    ),
    OnboardingSlide(
      image: 'assets/images/onboarding/slide_4.png',
      title: 'Создать книгу за 1 минуту',
      description: 'AI поможет собрать идеальную фотокнигу автоматически',
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Слой 1: PageView с изображениями (на весь экран без SafeArea)
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return OnboardingSlideWidget(slide: _slides[index]);
              },
            ),
          ),
          // Слой 2: Кнопка "Пропустить" вверху справа (если не последний слайд)
          if (!isLastPage)
            Positioned(
              top: 50,
              right: 16,
              child: TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Пропустить',
                  style: TextStyle(color: Color(0xFF7B68EE)),
                ),
              ),
            ),
          // Слой 3: Индикаторы, кнопка "Далее" и "Войти" внизу
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Индикаторы
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Color(0xFF7B68EE)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Кнопка "Далее" / "Начать создание"
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7B68EE),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isLastPage ? 'Начать создание' : 'Далее',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // Кнопка "Войти" если последний слайд
                if (isLastPage)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text('Войти'),
                    ),
                  )
                else
                  SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
