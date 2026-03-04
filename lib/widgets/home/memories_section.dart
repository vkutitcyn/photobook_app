import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'section_header.dart';

class MemoriesSection extends StatelessWidget {
  const MemoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.camera_alt,
          title: 'Недавние воспоминания',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: AppSpacing.horizontal, right: AppSpacing.horizontal),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) return const _PromoCard();
              final data = _memories[index - 1];
              return _MemoryCard(data: data);
            },
          ),
        ),
      ],
    );
  }

  static const _memories = [
    _MemoryData(date: 'Февраль 2026', location: 'Москва'),
    _MemoryData(date: 'Январь 2026', location: 'Санкт-Петербург'),
  ];
}

class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to AI auto-builder
      },
      child: Container(
        width: 160,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A3E), Color(0xFF19C5D1)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Соберём книгу\nиз любого события\nавтоматически',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  final _MemoryData data;

  const _MemoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to memory detail
      },
      child: Container(
        width: 160,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.photo_library, color: Colors.grey, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.date, style: AppTextStyles.date),
                  const SizedBox(height: 2),
                  Text('📍 ${data.location}', style: AppTextStyles.location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryData {
  final String date;
  final String location;

  const _MemoryData({required this.date, required this.location});
}
