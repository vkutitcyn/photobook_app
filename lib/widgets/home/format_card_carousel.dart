import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'section_header.dart';

class FormatCardCarousel extends StatelessWidget {
  const FormatCardCarousel({Key? key}) : super(key: key);

  static final _formats = [
    _FormatData(
      name: 'Мягкая обложка',
      image: 'assets/images/home/formats/soft.png',
      price: 'от 1499₽',
      oldPrice: '3 500₽',
      discount: '-43%',
      badge: 'Выгодно',
      badgeColor: const Color(0xFF7B68EE),
      description: 'Гибкая и лёгкая. Удобно листать и дарить без особого повода',
      tags: const ['Дети', 'Семья', 'Без повода'],
    ),
    _FormatData(
      name: 'Твёрдая обложка',
      image: 'assets/images/home/formats/hard.png',
      price: 'от 1999₽',
      oldPrice: '4 500₽',
      discount: '-56%',
      badge: 'Популярно',
      badgeColor: const Color(0xFF19C5D1),
      description: 'Классическая обложка для важных моментов. Прочная и долговечная',
      tags: const ['Путешествие', 'Книга года', 'День рождения'],
    ),
    _FormatData(
      name: 'Layflat',
      image: 'assets/images/home/formats/layflat.png',
      price: 'от 3499₽',
      oldPrice: '5 500₽',
      discount: '-36%',
      badge: 'На годы',
      badgeColor: const Color(0xFFFF8C42),
      description: 'Страницы раскрываются на 180°. Идеально для панорамных фото',
      tags: const ['Свадьба', 'История семьи'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.tune,
          title: 'Настрой идеальный формат',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: AppSpacing.horizontal,
              right: AppSpacing.horizontal,
            ),
            itemCount: _formats.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cardWidth =
                  MediaQuery.of(context).size.width - 32;
              return _FormatCard(
                format: _formats[index],
                cardWidth: cardWidth,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FormatCard extends StatelessWidget {
  final _FormatData format;
  final double cardWidth;

  const _FormatCard({required this.format, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to format detail
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            _buildImageSection(),
            Expanded(child: _buildTextSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      width: 140,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: SizedBox(
              width: 140,
              height: double.infinity,
              child: Image.asset(
                format.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.menu_book,
                    color: AppColors.primary,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: format.badgeColor,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Text(
                format.badge,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE63946),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Text(
                format.discount,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                // TODO: open details
              },
              child: const Text(
                'подробнее',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection() {
    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              format.name,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary1,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(format.price, style: AppTextStyles.price),
                const SizedBox(width: 6),
                Text(format.oldPrice, style: AppTextStyles.oldPrice),
              ],
            ),
            const SizedBox(height: 6),
            Text(format.description, style: AppTextStyles.body),
            const Spacer(),
            Text('Идеально для:', style: AppTextStyles.body),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: format.tags.map((tag) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormatData {
  final String name;
  final String image;
  final String price;
  final String oldPrice;
  final String discount;
  final String badge;
  final Color badgeColor;
  final String description;
  final List<String> tags;

  const _FormatData({
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.badge,
    required this.badgeColor,
    required this.description,
    required this.tags,
  });
}
