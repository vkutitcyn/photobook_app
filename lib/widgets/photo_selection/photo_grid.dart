import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/app_theme.dart';

class PhotoGrid extends StatelessWidget {
  final List<AssetEntity> photos;
  final Set<String> selectedIds;
  final ValueChanged<AssetEntity> onToggle;
  final bool showMonthLabels;
  final ScrollController? scrollController;

  const PhotoGrid({
    Key? key,
    required this.photos,
    required this.selectedIds,
    required this.onToggle,
    this.showMonthLabels = true,
    this.scrollController,
  }) : super(key: key);

  static const _months = [
    '', 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
  ];

  bool _isNewMonth(int index) {
    if (!showMonthLabels || index == 0) return index == 0 && showMonthLabels;
    final curr = photos[index].createDateTime;
    final prev = photos[index - 1].createDateTime;
    return curr.month != prev.month || curr.year != prev.year;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      addAutomaticKeepAlives: false,
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final asset = photos[index];
        final selected = selectedIds.contains(asset.id);
        final newMonth = _isNewMonth(index);

        return GestureDetector(
          onTap: () => onToggle(asset),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _PhotoThumbnail(asset: asset),
              if (newMonth)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _months[photos[index].createDateTime.month],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 6,
                bottom: 6,
                child: _SelectionCircle(selected: selected),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhotoThumbnail extends StatefulWidget {
  final AssetEntity asset;
  const _PhotoThumbnail({required this.asset});

  @override
  State<_PhotoThumbnail> createState() => _PhotoThumbnailState();
}

class _PhotoThumbnailState extends State<_PhotoThumbnail> {
  Uint8List? _thumb;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    final data = await widget.asset
        .thumbnailDataWithSize(const ThumbnailSize(200, 200));
    if (mounted && data != null) setState(() => _thumb = data);
  }

  @override
  Widget build(BuildContext context) {
    if (_thumb != null) {
      return Image.memory(_thumb!, fit: BoxFit.cover);
    }
    return Container(color: AppColors.surface);
  }
}

class _SelectionCircle extends StatelessWidget {
  final bool selected;
  const _SelectionCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
