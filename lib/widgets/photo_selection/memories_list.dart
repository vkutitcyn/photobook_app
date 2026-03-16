import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/app_theme.dart';

class MemoryGroup {
  final List<AssetEntity> photos;
  final DateTime startDate;
  final DateTime endDate;

  MemoryGroup({
    required this.photos,
    required this.startDate,
    required this.endDate,
  });

  static const _monthNames = [
    '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];

  String get title {
    if (startDate.day == endDate.day &&
        startDate.month == endDate.month &&
        startDate.year == endDate.year) {
      return '${startDate.day} ${_monthNames[startDate.month]} ${startDate.year}';
    }
    if (startDate.month == endDate.month && startDate.year == endDate.year) {
      return '${startDate.day}–${endDate.day} ${_monthNames[endDate.month]} ${endDate.year}';
    }
    return '${startDate.day} ${_monthNames[startDate.month]} — ${endDate.day} ${_monthNames[endDate.month]} ${endDate.year}';
  }

  AssetEntity get coverPhoto => photos.first;
  List<AssetEntity> get previewPhotos => photos.take(4).toList();
  int get count => photos.length;

  static List<MemoryGroup> groupPhotos(List<AssetEntity> allPhotos,
      {int maxDaysGap = 2, int minPhotos = 5}) {
    if (allPhotos.isEmpty) return [];

    final sorted = List<AssetEntity>.from(allPhotos)
      ..sort((a, b) => a.createDateTime.compareTo(b.createDateTime));

    final groups = <MemoryGroup>[];
    var currentGroup = <AssetEntity>[sorted.first];

    for (var i = 1; i < sorted.length; i++) {
      final daysDiff = sorted[i]
          .createDateTime
          .difference(sorted[i - 1].createDateTime)
          .inDays;

      if (daysDiff <= maxDaysGap) {
        currentGroup.add(sorted[i]);
      } else {
        if (currentGroup.length >= minPhotos) {
          groups.add(MemoryGroup(
            photos: currentGroup,
            startDate: currentGroup.first.createDateTime,
            endDate: currentGroup.last.createDateTime,
          ));
        }
        currentGroup = [sorted[i]];
      }
    }
    if (currentGroup.length >= minPhotos) {
      groups.add(MemoryGroup(
        photos: currentGroup,
        startDate: currentGroup.first.createDateTime,
        endDate: currentGroup.last.createDateTime,
      ));
    }

    groups.sort((a, b) => b.startDate.compareTo(a.startDate));
    return groups;
  }
}

class MemoriesList extends StatelessWidget {
  final List<MemoryGroup> memories;
  final ValueChanged<MemoryGroup> onMemoryTap;

  const MemoriesList({
    Key? key,
    required this.memories,
    required this.onMemoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Пока нет воспоминаний.\nДобавьте больше фото в галерею',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: AppColors.textSecondary2,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: memories.length,
      itemBuilder: (context, index) {
        return _MemoryCard(
          memory: memories[index],
          onTap: () => onMemoryTap(memories[index]),
        );
      },
    );
  }
}

class _MemoryCard extends StatefulWidget {
  final MemoryGroup memory;
  final VoidCallback onTap;

  const _MemoryCard({required this.memory, required this.onTap});

  @override
  State<_MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<_MemoryCard> {
  Uint8List? _heroThumb;
  final List<Uint8List?> _previews = [null, null, null, null];

  @override
  void initState() {
    super.initState();
    _loadThumbs();
  }

  Future<void> _loadThumbs() async {
    final hero = await widget.memory.coverPhoto
        .thumbnailDataWithSize(const ThumbnailSize(600, 600));
    if (mounted) setState(() => _heroThumb = hero);

    final previews = widget.memory.previewPhotos;
    for (var i = 0; i < previews.length && i < 4; i++) {
      final t = await previews[i]
          .thumbnailDataWithSize(const ThumbnailSize(200, 200));
      if (mounted) setState(() => _previews[i] = t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                width: double.infinity,
                height: 280,
                child: _heroThumb != null
                    ? Image.memory(_heroThumb!, fit: BoxFit.cover)
                    : Container(color: AppColors.surface),
              ),
            ),
            _buildPreviewRow(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.memory.title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary1,
                    ),
                  ),
                ),
                Text(
                  '${widget.memory.count} фото',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: AppColors.textSecondary2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow() {
    final count = widget.memory.previewPhotos.length.clamp(0, 4);
    return SizedBox(
      height: 80,
      child: Row(
        children: List.generate(count, (i) {
          BorderRadius? radius;
          if (i == 0 && count > 1) {
            radius = const BorderRadius.only(
                bottomLeft: Radius.circular(16));
          } else if (i == count - 1) {
            radius = const BorderRadius.only(
                bottomRight: Radius.circular(16));
          }

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i > 0 ? 2 : 0),
              child: ClipRRect(
                borderRadius: radius ?? BorderRadius.zero,
                child: SizedBox(
                  height: 80,
                  child: _previews[i] != null
                      ? Image.memory(_previews[i]!, fit: BoxFit.cover)
                      : Container(color: AppColors.surface),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
