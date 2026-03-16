import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/segment_control.dart';
import '../editor/photo_selection_screen.dart';

class BookParametersScreen extends StatefulWidget {
  final String coverType;

  const BookParametersScreen({Key? key, required this.coverType})
      : super(key: key);

  @override
  State<BookParametersScreen> createState() => _BookParametersScreenState();
}

class _BookParametersScreenState extends State<BookParametersScreen> {
  int _orientationIndex = 1; // default: Квадрат
  int _sizeIndex = 1; // default: M for square
  int _coverFinishIndex = 0; // default: Глянцевая
  int _paperTypeIndex = 0; // default: Полуглянцевые

  late PageController _pageController;

  static const _orientations = [
    SegmentItem(label: 'Горизонтальная'),
    SegmentItem(label: 'Квадрат'),
    SegmentItem(label: 'Вертикальная'),
  ];

  static const _sizes = <int, List<SegmentItem>>{
    0: [
      SegmentItem(label: 'S', sublabel: '21 x 14 см'),
      SegmentItem(label: 'L', sublabel: '29 x 21 см'),
    ],
    1: [
      SegmentItem(label: 'S', sublabel: '15 x 15 см'),
      SegmentItem(label: 'M', sublabel: '20 x 20 см'),
      SegmentItem(label: 'L', sublabel: '30 x 30 см'),
    ],
    2: [
      SegmentItem(label: 'S', sublabel: '14 x 21 см'),
      SegmentItem(label: 'L', sublabel: '21 x 29 см'),
    ],
  };

  static const _defaultSizeIndex = <int, int>{0: 0, 1: 1, 2: 0};

  static const _coverFinishes = [
    SegmentItem(
      label: 'Глянцевая',
      imagePath: 'assets/images/book_params/options/glossi.png',
    ),
    SegmentItem(
      label: 'Матовая',
      imagePath: 'assets/images/book_params/options/matte.png',
    ),
  ];

  static const _paperTypes = [
    SegmentItem(
      label: 'Полуглянцевые',
      imagePath: 'assets/images/book_params/options/semi_gloss.png',
    ),
    SegmentItem(
      label: 'Матовые',
      imagePath: 'assets/images/book_params/options/matte_2.png',
    ),
  ];

  static const _previewImages = [
    'assets/images/book_params/preview/size.png',
    'assets/images/book_params/preview/book_on_table.png',
  ];

  static const _prices = {'soft': 1499, 'hard': 2499, 'layflat': 2999};
  static const _maxPages = {'soft': '400', 'hard': '400', 'layflat': '120'};

  int get _price => _prices[widget.coverType] ?? 1499;
  String get _max => _maxPages[widget.coverType] ?? '400';

  List<SegmentItem> get _currentSizes => _sizes[_orientationIndex]!;

  String get _orientationLabel => _orientations[_orientationIndex].label;
  String get _sizeLabel => _currentSizes[_sizeIndex].sublabel ?? '';
  String get _coverFinishLabel =>
      _coverFinishes[_coverFinishIndex].label.toLowerCase();
  String get _paperLabel =>
      _paperTypes[_paperTypeIndex].label.toLowerCase();

  String get _summary =>
      '$_orientationLabel, $_sizeLabel, $_coverFinishLabel обложка, $_paperLabel страницы';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _sizeIndex = _defaultSizeIndex[_orientationIndex]!;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onOrientationChanged(int i) {
    setState(() {
      _orientationIndex = i;
      _sizeIndex = _defaultSizeIndex[i]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(topPadding),
                  const SizedBox(height: 16),
                  _buildCarousel(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.horizontal),
                    child: SegmentControl(
                      items: _orientations,
                      selectedIndex: _orientationIndex,
                      onChanged: _onOrientationChanged,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.horizontal),
                    child: SegmentControl(
                      items: _currentSizes,
                      selectedIndex: _sizeIndex,
                      onChanged: (i) => setState(() => _sizeIndex = i),
                      height: 52,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.surface),
                  const SizedBox(height: 16),
                  _buildSelectorSection(
                    title: 'Обложка',
                    items: _coverFinishes,
                    selectedIndex: _coverFinishIndex,
                    onChanged: (i) =>
                        setState(() => _coverFinishIndex = i),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.surface),
                  const SizedBox(height: 16),
                  _buildSelectorSection(
                    title: 'Страницы',
                    items: _paperTypes,
                    selectedIndex: _paperTypeIndex,
                    onChanged: (i) =>
                        setState(() => _paperTypeIndex = i),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar(double topPadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
              'Параметры книги',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary1,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 360,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: _previewImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0EB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  _previewImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(Icons.menu_book, size: 64, color: AppColors.textSecondary2),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectorSection({
    required String title,
    required List<SegmentItem> items,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary1,
            ),
          ),
          const SizedBox(height: 8),
          SegmentControl(
            items: items,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
            height: 52,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                color: AppColors.surface,
                child: Image.asset(
                  _previewImages[0],
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.menu_book,
                    size: 20,
                    color: AppColors.textSecondary2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceText(),
                  const SizedBox(height: 2),
                  Text(
                    _summary,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 120,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhotoSelectionScreen(
                        coverType: widget.coverType,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
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

  Widget _buildPriceText() {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary1,
        ),
        children: [
          TextSpan(
            text: '$_price₽',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const TextSpan(text: ' за 20 стр, макс '),
          TextSpan(
            text: _max,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const TextSpan(text: ' стр'),
        ],
      ),
    );
  }
}
