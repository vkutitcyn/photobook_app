import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/segment_control.dart';
import 'book_parameters_screen.dart';

class _CoverTypeData {
  final String type;
  final String image;
  final String annotation;
  final String title;
  final String price;
  final String maxPages;
  final String description;
  final String segmentLabel;

  const _CoverTypeData({
    required this.type,
    required this.image,
    required this.annotation,
    required this.title,
    required this.price,
    required this.maxPages,
    required this.description,
    required this.segmentLabel,
  });
}

const _coverTypes = [
  _CoverTypeData(
    type: 'soft',
    image: 'assets/images/book_params/covers/softcover.png',
    annotation: 'мягкая\nобложка',
    title: 'Самая лёгкая',
    price: '1 499₽',
    maxPages: '400',
    description:
        'Гибкая и удобная книга, чтобы сохранить повседневные, детские и семейные фото из вашей галереи',
    segmentLabel: 'Мягкая обложка',
  ),
  _CoverTypeData(
    type: 'hard',
    image: 'assets/images/book_params/covers/hardcover.png',
    annotation: 'твёрдая\nобложка',
    title: 'Самая популярная',
    price: '2 499₽',
    maxPages: '400',
    description:
        'Долговечная и аккуратная книга для истории вашего путешествия, книги года или дня рождения',
    segmentLabel: 'Твёрдая обложка',
  ),
  _CoverTypeData(
    type: 'layflat',
    image: 'assets/images/book_params/covers/layflat.png',
    annotation: 'раскрывается на 180°',
    title: 'Самая эффектная',
    price: '2 999₽',
    maxPages: '120',
    description:
        'Формат, который особенно красиво передаёт важные моменты: свадьбу, юбилей или историю семьи',
    segmentLabel: 'Layflat',
  ),
];

class CoverTypeScreen extends StatefulWidget {
  final String initialType;

  const CoverTypeScreen({Key? key, this.initialType = 'soft'}) : super(key: key);

  @override
  State<CoverTypeScreen> createState() => _CoverTypeScreenState();
}

class _CoverTypeScreenState extends State<CoverTypeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _coverTypes.indexWhere((c) => c.type == widget.initialType);
    if (_selectedIndex < 0) _selectedIndex = 0;
  }

  _CoverTypeData get _current => _coverTypes[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Image.asset(
              _current.image,
              key: ValueKey(_current.type),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, _, _) => Container(color: const Color(0xFF2A2A3E)),
            ),
          ),

          Positioned(
            top: topPadding + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.close, size: 24, color: Colors.black),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _current.title,
                key: ValueKey('title_${_current.type}'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildPriceRow(),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _current.description,
                key: ValueKey('desc_${_current.type}'),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SegmentControl(
              items: _coverTypes
                  .map((c) => SegmentItem(label: c.segmentLabel))
                  .toList(),
              selectedIndex: _selectedIndex,
              onChanged: (i) => setState(() => _selectedIndex = i),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Далее'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow() {
    return RichText(
      key: ValueKey('price_${_current.type}'),
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary1,
        ),
        children: [
          const TextSpan(text: 'От '),
          TextSpan(
            text: _current.price,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const TextSpan(text: ' за 20 страниц, максимум '),
          TextSpan(
            text: _current.maxPages,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const TextSpan(text: ' страниц'),
        ],
      ),
    );
  }

  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookParametersScreen(coverType: _current.type),
      ),
    );
  }
}
