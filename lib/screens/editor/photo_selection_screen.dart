import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/segment_control.dart';
import '../../widgets/photo_selection/photo_grid.dart';
import '../../widgets/photo_selection/photo_bottom_bar.dart';
import '../../widgets/photo_selection/year_filter_bar.dart';
import '../../widgets/photo_selection/albums_grid.dart';
import '../../widgets/photo_selection/memories_list.dart';
import 'album_detail_screen.dart';
import 'memory_detail_screen.dart';
import 'selected_photos_screen.dart';

class PhotoSelectionScreen extends StatefulWidget {
  final String coverType;

  const PhotoSelectionScreen({Key? key, required this.coverType})
      : super(key: key);

  @override
  State<PhotoSelectionScreen> createState() => _PhotoSelectionScreenState();
}

class _PhotoSelectionScreenState extends State<PhotoSelectionScreen> {
  int _tabIndex = 0;
  bool _permissionGranted = false;
  bool _loading = true;

  final Set<String> _selectedIds = {};
  Uint8List? _lastThumb;

  // Film roll
  List<AssetEntity> _allPhotos = [];
  List<AssetEntity> _filteredPhotos = [];
  int _photoPage = 0;
  bool _hasMorePhotos = true;
  List<int> _years = [];
  int? _selectedYear;
  final ScrollController _filmScrollController = ScrollController();

  // Albums
  List<AssetPathEntity> _albums = [];

  // Memories
  List<MemoryGroup> _memories = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _filmScrollController.addListener(_onFilmScroll);
  }

  @override
  void dispose() {
    _filmScrollController.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    setState(() => _loading = true);
    debugPrint('Android version: ${Platform.operatingSystemVersion}');

    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    debugPrint('Permission result: $permission');

    final bool hasAccess =
        permission == PermissionState.authorized ||
        permission == PermissionState.limited;
    debugPrint('hasAccess: $hasAccess');

    if (hasAccess) {
      if (mounted) setState(() => _permissionGranted = true);

      try {
        await _loadInitialData();
      } catch (e, stack) {
        debugPrint('Error loading photos: $e');
        debugPrint('$stack');
      }

      if (mounted) setState(() => _loading = false);
    } else {
      if (mounted) {
        setState(() {
          _permissionGranted = false;
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadPhotos(), _loadAlbums()]);
    _buildMemories();
  }

  Future<void> _loadPhotos() async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );
    if (paths.isEmpty) return;

    final allPath = paths.firstWhere((p) => p.isAll, orElse: () => paths.first);
    final assets =
        await allPath.getAssetListPaged(page: _photoPage, size: 80);

    final yearSet = <int>{};
    for (final a in assets) {
      yearSet.add(a.createDateTime.year);
    }

    setState(() {
      _allPhotos = assets;
      _filteredPhotos = assets;
      _hasMorePhotos = assets.length == 80;
      _years = yearSet.toList()..sort((a, b) => b.compareTo(a));
    });
  }

  Future<void> _loadMorePhotos() async {
    if (!_hasMorePhotos) return;
    _photoPage++;

    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );
    if (paths.isEmpty) return;

    final allPath = paths.firstWhere((p) => p.isAll, orElse: () => paths.first);
    final assets =
        await allPath.getAssetListPaged(page: _photoPage, size: 80);

    final yearSet = <int>{};
    for (final a in _allPhotos) {
      yearSet.add(a.createDateTime.year);
    }
    for (final a in assets) {
      yearSet.add(a.createDateTime.year);
    }

    setState(() {
      _allPhotos.addAll(assets);
      _hasMorePhotos = assets.length == 80;
      _years = yearSet.toList()..sort((a, b) => b.compareTo(a));
      _applyYearFilter();
    });
  }

  Future<void> _loadAlbums() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: false,
    );
    setState(() => _albums = albums);
  }

  void _buildMemories() {
    _memories = MemoryGroup.groupPhotos(_allPhotos);
  }

  void _applyYearFilter() {
    if (_selectedYear == null) {
      _filteredPhotos = _allPhotos;
    } else {
      _filteredPhotos = _allPhotos
          .where((a) => a.createDateTime.year == _selectedYear)
          .toList();
    }
  }

  void _onFilmScroll() {
    if (_filmScrollController.position.pixels >=
        _filmScrollController.position.maxScrollExtent - 200) {
      _loadMorePhotos();
    }
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

  void _selectAllVisible() {
    setState(() {
      for (final p in _filteredPhotos) {
        _selectedIds.add(p.id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _lastThumb = null;
    });
  }

  void _openSelectedPhotos() async {
    final allAssets = _allPhotos
        .where((a) => _selectedIds.contains(a.id))
        .toList();

    final result = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => SelectedPhotosScreen(
          selectedAssets: allAssets,
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

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: topPadding),
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SegmentControl(
              items: const [
                SegmentItem(label: 'Фотопленка'),
                SegmentItem(label: 'Альбомы'),
                SegmentItem(label: 'Воспоминания'),
              ],
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(child: _buildContent()),
          PhotoBottomBar(
            selectedCount: _selectedIds.length,
            lastPhotoThumb: _lastThumb,
            onSkipOrNext: () {
              // TODO: navigate to next step
            },
            onViewSelected: _openSelectedPhotos,
            onClearSelection: _clearSelection,
          ),
        ],
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
            onTap: () => Navigator.pop(context),
            child:
                const Icon(Icons.close, size: 24, color: AppColors.textPrimary1),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (!_permissionGranted) {
      return _buildPermissionDenied();
    }

    switch (_tabIndex) {
      case 0:
        return _buildFilmRoll();
      case 1:
        return AlbumsGrid(
          albums: _albums,
          onAlbumTap: (album) => _openAlbum(album),
        );
      case 2:
        return MemoriesList(
          memories: _memories,
          onMemoryTap: (m) => _openMemory(m),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildFilmRoll() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedYear == null
                              ? 'Все фото'
                              : '$_selectedYear',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary1,
                          ),
                        ),
                        Text(
                          '${_filteredPhotos.length} фото',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: AppColors.textSecondary2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _selectAllVisible,
                    child: const Text(
                      'Выбрать все',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PhotoGrid(
                photos: _filteredPhotos,
                selectedIds: _selectedIds,
                onToggle: _togglePhoto,
                scrollController: _filmScrollController,
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: YearFilterBar(
            years: _years,
            selectedYear: _selectedYear,
            onChanged: (y) {
              setState(() {
                _selectedYear = y;
                _applyYearFilter();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_library_outlined,
                size: 64, color: AppColors.textSecondary2),
            const SizedBox(height: 16),
            const Text(
              'Нет доступа к галерее',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Разрешите доступ к фото в настройках',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: AppColors.textSecondary2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _requestPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F0F0),
                    foregroundColor: AppColors.textPrimary1,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Повторить'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => PhotoManager.openSetting(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Открыть настройки'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openAlbum(AssetPathEntity album) async {
    final result = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumDetailScreen(
          album: album,
          selectedIds: Set<String>.from(_selectedIds),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedIds
          ..clear()
          ..addAll(result);
      });
      _updateLastThumb();
    }
  }

  void _openMemory(MemoryGroup memory) async {
    final result = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryDetailScreen(
          memory: memory,
          selectedIds: Set<String>.from(_selectedIds),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedIds
          ..clear()
          ..addAll(result);
      });
      _updateLastThumb();
    }
  }

  Future<void> _updateLastThumb() async {
    if (_selectedIds.isEmpty) {
      _lastThumb = null;
      return;
    }
    final lastId = _selectedIds.last;
    final match = _allPhotos.where((a) => a.id == lastId);
    if (match.isNotEmpty) {
      final t =
          await match.first.thumbnailDataWithSize(const ThumbnailSize(200, 200));
      if (mounted) setState(() => _lastThumb = t);
    }
  }
}
