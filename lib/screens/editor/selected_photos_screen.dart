import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/app_theme.dart';

class SelectedPhotosScreen extends StatefulWidget {
  final List<AssetEntity> selectedAssets;
  final Set<String> selectedIds;

  const SelectedPhotosScreen({
    Key? key,
    required this.selectedAssets,
    required this.selectedIds,
  }) : super(key: key);

  @override
  State<SelectedPhotosScreen> createState() => _SelectedPhotosScreenState();
}

class _SelectedPhotosScreenState extends State<SelectedPhotosScreen> {
  late Set<String> _selectedIds;
  late List<AssetEntity> _assets;

  final Set<String> _markedForDeletion = {};
  bool _deleteMode = false;

  Uint8List? _lastThumb;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedIds;
    _assets = List.from(widget.selectedAssets);
    _loadLastThumb();
  }

  Future<void> _loadLastThumb() async {
    if (_assets.isNotEmpty) {
      final t = await _assets.last
          .thumbnailDataWithSize(const ThumbnailSize(200, 200));
      if (mounted) setState(() => _lastThumb = t);
    }
  }

  void _onPhotoTap(AssetEntity asset) {
    setState(() {
      if (!_deleteMode) {
        _deleteMode = true;
        _markedForDeletion.add(asset.id);
      } else {
        if (_markedForDeletion.contains(asset.id)) {
          _markedForDeletion.remove(asset.id);
          if (_markedForDeletion.isEmpty) _deleteMode = false;
        } else {
          _markedForDeletion.add(asset.id);
        }
      }
    });
  }

  void _selectAllForDeletion() {
    setState(() {
      _deleteMode = true;
      for (final a in _assets) {
        _markedForDeletion.add(a.id);
      }
    });
  }

  void _cancelDeletion() {
    setState(() {
      _markedForDeletion.clear();
      _deleteMode = false;
    });
  }

  void _confirmDeletion() {
    setState(() {
      _selectedIds.removeAll(_markedForDeletion);
      _assets.removeWhere((a) => _markedForDeletion.contains(a.id));
      _markedForDeletion.clear();
      _deleteMode = false;
    });
    _loadLastThumb();
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
                    const SizedBox(height: 8),
                    _buildInfoBar(),
                    const SizedBox(height: 8),
                    Expanded(child: _buildGrid()),
                  ],
                ),
              ),
            ),
            _deleteMode ? _buildDeleteBar() : _buildNormalBar(),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          const SizedBox(width: 24),
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
            onTap: () => Navigator.pop(context, _selectedIds),
            child:
                const Icon(Icons.close, size: 24, color: AppColors.textPrimary1),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildThumbBadge(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _deleteMode ? 'Фото на удаление' : 'Выбрано фото',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: AppColors.textPrimary1,
              ),
            ),
          ),
          if (_deleteMode)
            GestureDetector(
              onTap: _selectAllForDeletion,
              child: const Text(
                'Выбрать все',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: confirm selection and go next
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Далее'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbBadge() {
    final count = _deleteMode ? _markedForDeletion.length : _assets.length;

    if (_lastThumb != null) {
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
                child: Image.memory(_lastThumb!, fit: BoxFit.cover),
              ),
              Container(
                color: _deleteMode
                    ? const Color(0xFFE63946).withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
              Center(
                child: Text(
                  '$count',
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
      decoration: BoxDecoration(
        color: _deleteMode
            ? const Color(0xFFE63946)
            : AppColors.textSecondary2,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
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

  Widget _buildGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      addAutomaticKeepAlives: false,
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        final asset = _assets[index];
        final marked = _markedForDeletion.contains(asset.id);

        return GestureDetector(
          onTap: () => _onPhotoTap(asset),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _Thumb(asset: asset),
              if (marked)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE63946),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNormalBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
    );
  }

  Widget _buildDeleteBar() {
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
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _cancelDeletion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F0F0),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Отменить выделение'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed:
                      _markedForDeletion.isNotEmpty ? _confirmDeletion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE63946),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Удалить'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatefulWidget {
  final AssetEntity asset;
  const _Thumb({required this.asset});

  @override
  State<_Thumb> createState() => _ThumbState();
}

class _ThumbState extends State<_Thumb> {
  Uint8List? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await widget.asset
        .thumbnailDataWithSize(const ThumbnailSize(200, 200));
    if (mounted && d != null) setState(() => _data = d);
  }

  @override
  Widget build(BuildContext context) {
    if (_data != null) return Image.memory(_data!, fit: BoxFit.cover);
    return Container(color: AppColors.surface);
  }
}
