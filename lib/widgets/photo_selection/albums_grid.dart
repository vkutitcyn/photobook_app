import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/app_theme.dart';

class AlbumsGrid extends StatelessWidget {
  final List<AssetPathEntity> albums;
  final ValueChanged<AssetPathEntity> onAlbumTap;

  const AlbumsGrid({
    Key? key,
    required this.albums,
    required this.onAlbumTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return _AlbumCard(
          album: albums[index],
          onTap: () => onAlbumTap(albums[index]),
        );
      },
    );
  }
}

class _AlbumCard extends StatefulWidget {
  final AssetPathEntity album;
  final VoidCallback onTap;

  const _AlbumCard({required this.album, required this.onTap});

  @override
  State<_AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<_AlbumCard> {
  Uint8List? _coverThumb;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _count = await widget.album.assetCountAsync;
    if (_count > 0) {
      final assets =
          await widget.album.getAssetListRange(start: 0, end: 1);
      if (assets.isNotEmpty) {
        final thumb =
            await assets.first.thumbnailDataWithSize(const ThumbnailSize(400, 400));
        if (mounted) setState(() => _coverThumb = thumb);
        return;
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_coverThumb != null)
              Image.memory(_coverThumb!, fit: BoxFit.cover)
            else
              Container(
                color: AppColors.surface,
                child: const Icon(Icons.photo_library,
                    size: 40, color: AppColors.textSecondary2),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                widget.album.name,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
