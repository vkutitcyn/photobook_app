import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontal),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary1),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.sectionTitle),
        ],
      ),
    );
  }
}
