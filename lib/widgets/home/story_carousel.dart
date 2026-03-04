import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'section_header.dart';

class StoryCarousel extends StatelessWidget {
  const StoryCarousel({Key? key}) : super(key: key);

  static const _stories = [
    _StoryData('Путешествие', 'assets/images/home/categories/travel.png'),
    _StoryData('Семья', 'assets/images/home/categories/family.png'),
    _StoryData('Свадьба', 'assets/images/home/categories/wedding.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.auto_stories,
          title: 'Выбери свою историю',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: AppSpacing.horizontal, right: AppSpacing.horizontal),
            itemCount: _stories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final story = _stories[index];
              return _StoryCard(story: story);
            },
          ),
        ),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  final _StoryData story;

  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to story category
      },
      child: SizedBox(
        width: 160,
        height: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                story.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  child: const Icon(Icons.image, color: Colors.white54, size: 48),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Text(
                  story.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryData {
  final String title;
  final String image;

  const _StoryData(this.title, this.image);
}
