import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'section_header.dart';

class PopularBooksCarousel extends StatelessWidget {
  const PopularBooksCarousel({Key? key}) : super(key: key);

  static const _books = [
    _BookData(
      title: 'Тревелбук',
      image: 'assets/images/home/books/travelbook.png',
      price: 'от 1 499₽',
      oldPrice: '3 500₽',
    ),
    _BookData(
      title: 'Год в фотографиях',
      image: 'assets/images/home/books/year_review.png',
      price: 'от 2 499₽',
      oldPrice: '4 000₽',
    ),
    _BookData(
      title: 'you&me',
      image: 'assets/images/home/books/me_you.png',
      price: 'от 2 999₽',
      oldPrice: '5 000₽',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.star,
          title: 'Самые популярные книги',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: AppSpacing.horizontal, right: AppSpacing.horizontal),
            itemCount: _books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final book = _books[index];
              return _BookCard(book: book);
            },
          ),
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final _BookData book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to book detail
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.card),
                topRight: Radius.circular(AppRadius.card),
              ),
              child: SizedBox(
                width: 140,
                height: 140,
                child: Image.asset(
                  book.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    child: const Icon(Icons.menu_book, color: AppColors.primary, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(book.price, style: AppTextStyles.price),
                      const SizedBox(width: 4),
                      Text(book.oldPrice, style: AppTextStyles.oldPrice),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.title,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookData {
  final String title;
  final String image;
  final String price;
  final String oldPrice;

  const _BookData({
    required this.title,
    required this.image,
    required this.price,
    required this.oldPrice,
  });
}
