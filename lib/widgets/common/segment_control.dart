import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class SegmentItem {
  final String label;
  final String? sublabel;
  final String? imagePath;

  const SegmentItem({
    required this.label,
    this.sublabel,
    this.imagePath,
  });
}

class SegmentControl extends StatelessWidget {
  final List<SegmentItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;

  const SegmentControl({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 44,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: _buildContent(item, selected),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent(SegmentItem item, bool selected) {
    final hasImage = item.imagePath != null;
    final hasSublabel = item.sublabel != null;

    if (hasImage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                item.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.surface,
                  child: const Icon(Icons.image, size: 16, color: AppColors.textSecondary2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              item.label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.textPrimary1 : AppColors.textSecondary2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    if (hasSublabel) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.textPrimary1 : AppColors.textSecondary2,
            ),
          ),
          Text(
            item.sublabel!,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: selected ? AppColors.textPrimary1 : AppColors.textSecondary2,
            ),
          ),
        ],
      );
    }

    return Center(
      child: Text(
        item.label,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? AppColors.textPrimary1 : AppColors.textSecondary2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
