import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/app_theme.dart';
import '../../widgets/photo_selection/photo_grid.dart';
import '../../widgets/photo_selection/photo_bottom_bar.dart';
import '../../widgets/photo_selection/memories_list.dart';
import 'selected_photos_screen.dart';

class MemoryDetailScreen extends StatefulWidget {
  final MemoryGroup memory;
  final Set<String> selectedIds;

  const MemoryDetailScreen({
    Key? key,
    required this.memory,
    required this.selectedIds,
  }) : super(key: key);

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  late Set<String> _selectedIds;
  Uint8List? _coverThumb;
  Uint8List? _lastThumb;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedIds;
    _loadCover();
  }

  Future<void> _loadCover() async {
    final cover = await widget.memory.coverPhoto
        .thumbnailDataWithSize(const ThumbnailSize(600, 600));
    if (mounted) setState(() => _coverThumb = cover);
  }

  void _togglePhoto(AssetEntity asset) async {
    setState(() {
      if (_selectedIds.contains(asset.id)) {
        _selectedIds.remove(asset.id);
      } else {
        _selectedIds.add(asset.id);
      }
    });
    if (_selectedIds.isNotEmpty) {
      final thumb =
          await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));
      if (mounted) setState(() => _lastThumb = thumb);
    }
  }

  void _selectAll() {
    setState(() {
      for (final p in widget.memory.photos) {
        _selectedIds.add(p.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _selectedIds);
      },
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDragHandle(),
                    _buildHeader(),
                    Expanded(child: _buildBody()),
                  ],
                ),
              ),
            ),
            PhotoBottomBar(
              selectedCount: _selectedIds.length,
              lastPhotoThumb: _lastThumb,
              onSkipOrNext: () {
                // TODO
              },
              onViewSelected: () => _openSelectedPhotos(),
              onClearSelection: () => setState(() {
                _selectedIds.clear();
                _lastThumb = null;
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFD0D0D0),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context, _selectedIds),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
            ),
          ),
          const Expanded(
            child: Text(
              'Выбор фото',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary1,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Icon(Icons.close, size: 24, color: AppColors.textPrimary1),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHero()),
        SliverFillRemaining(
          child: PhotoGrid(
            photos: widget.memory.photos,
            selectedIds: _selectedIds,
            onToggle: _togglePhoto,
            showMonthLabels: false,
          ),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: _coverThumb != null
                ? Image.memory(_coverThumb!, fit: BoxFit.cover)
                : Container(color: AppColors.surface),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.memory.title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${widget.memory.count} фото',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _selectAll,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Выбрать все',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openSelectedPhotos() async {
    final selectedAssets = widget.memory.photos
        .where((a) => _selectedIds.contains(a.id))
        .toList();
    final result = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => SelectedPhotosScreen(
          selectedAssets: selectedAssets,
          selectedIds: Set<String>.from(_selectedIds),
        ),
        fullscreenDialog: true,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedIds
          ..clear()
          ..addAll(result);
      });
    }
  }
}
