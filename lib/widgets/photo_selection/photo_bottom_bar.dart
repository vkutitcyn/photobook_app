import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PhotoBottomBar extends StatelessWidget {
  final int selectedCount;
  final Uint8List? lastPhotoThumb;
  final VoidCallback onSkipOrNext;
  final VoidCallback onViewSelected;
  final VoidCallback onClearSelection;

  const PhotoBottomBar({
    Key? key,
    required this.selectedCount,
    this.lastPhotoThumb,
    required this.onSkipOrNext,
    required this.onViewSelected,
    required this.onClearSelection,
  }) : super(key: key);

  bool get _hasSelection => selectedCount > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_hasSelection) ...[
              _buildClearButton(),
              const SizedBox(width: 8),
            ],
            GestureDetector(
              onTap: _hasSelection ? onViewSelected : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCountBadge(),
                  const SizedBox(width: 8),
                  Text(
                    'Выбрано фото',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: _hasSelection
                          ? AppColors.textPrimary1
                          : AppColors.textSecondary2,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 140,
              height: 48,
              child: ElevatedButton(
                onPressed: onSkipOrNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(_hasSelection ? 'Далее' : 'Пропустить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: onClearSelection,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.close, size: 18, color: Colors.black),
      ),
    );
  }

  Widget _buildCountBadge() {
    if (_hasSelection && lastPhotoThumb != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Image.memory(lastPhotoThumb!, fit: BoxFit.cover),
              ),
              Center(
                child: Text(
                  '$selectedCount',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.textSecondary2,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$selectedCount',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
