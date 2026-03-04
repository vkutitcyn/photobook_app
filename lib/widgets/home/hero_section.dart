import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 440,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/home/hero.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF1A1A2E),
            ),
          ),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),

          Positioned(
            top: topPadding + 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.photo_album,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: topPadding + 12,
            right: AppSpacing.horizontal,
            child: GestureDetector(
              onTap: () {
                // TODO: open FAQ
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'СОБЕРИ ФОТОКНИГУ',
                    style: AppTextStyles.heroTitle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'ЗА 10 МИНУТ',
                    style: AppTextStyles.heroAccent,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Креатив без усилий с помощью AI',
                    style: AppTextStyles.heroSubtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isPressed = true),
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapCancel: () => setState(() => _isPressed = false),
                    onTap: () {
                      // TODO: navigate to creation flow
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: _isPressed
                            ? AppColors.primaryPressed
                            : AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppRadius.button),
                      ),
                      alignment: Alignment.center,
                      child: Text('Начать', style: AppTextStyles.buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
