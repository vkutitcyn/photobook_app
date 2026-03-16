import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class YearFilterBar extends StatelessWidget {
  final List<int> years;
  final int? selectedYear;
  final ValueChanged<int?> onChanged;

  const YearFilterBar({
    Key? key,
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: years.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final active = selectedYear == null;
            return _buildChip('Все', active, () => onChanged(null));
          }
          final year = years[index - 1];
          final active = selectedYear == year;
          return _buildChip('$year', active, () => onChanged(year));
        },
      ),
    );
  }

  Widget _buildChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: active
              ? null
              : Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? AppColors.primary : AppColors.textPrimary1,
          ),
        ),
      ),
    );
  }
}
