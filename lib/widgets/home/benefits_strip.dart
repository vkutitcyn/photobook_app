import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class BenefitsStrip extends StatefulWidget {
  const BenefitsStrip({Key? key}) : super(key: key);

  @override
  State<BenefitsStrip> createState() => _BenefitsStripState();
}

class _BenefitsStripState extends State<BenefitsStrip> {
  static const _items = [
    _BenefitItem(Icons.auto_awesome, 'Умные AI-инструменты'),
    _BenefitItem(Icons.camera_alt, 'Быстрая загрузка фото'),
    _BenefitItem(Icons.dashboard_customize, 'Шаблоны'),
    _BenefitItem(Icons.palette, 'Персонализация'),
    _BenefitItem(Icons.local_shipping, 'Доставка по всей России'),
  ];

  static const int _copies = 4;
  static const double _autoScrollSpeed = 50.0; // dp per second

  late ScrollController _scrollController;
  Timer? _autoScrollTimer;
  Timer? _resumeTimer;
  bool _isUserScrolling = false;
  double _singleSetWidth = 0;
  final GlobalKey _rowKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureAndStart();
    });
  }

  void _measureAndStart() {
    final renderBox =
        _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _singleSetWidth = renderBox.size.width;
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (_singleSetWidth == 0 || !mounted) return;

    const interval = Duration(milliseconds: 16); // ~60fps
    final step = _autoScrollSpeed * 0.016;

    _autoScrollTimer = Timer.periodic(interval, (_) {
      if (!mounted || _isUserScrolling || !_scrollController.hasClients) return;

      var newOffset = _scrollController.offset + step;

      if (newOffset >= _singleSetWidth * 2) {
        newOffset -= _singleSetWidth;
      }

      _scrollController.jumpTo(newOffset);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _scheduleResume() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && !_isUserScrolling) {
        _normalizePosition();
        _startAutoScroll();
      }
    });
  }

  void _normalizePosition() {
    if (!_scrollController.hasClients || _singleSetWidth == 0) return;
    final offset = _scrollController.offset;
    if (offset >= _singleSetWidth * 2) {
      _scrollController.jumpTo(offset - _singleSetWidth);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _isUserScrolling = true;
      _resumeTimer?.cancel();
      _stopAutoScroll();
    } else if (notification is ScrollEndNotification) {
      _isUserScrolling = false;
      _normalizePosition();
      _scheduleResume();
    }
    return false;
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _resumeTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildItemRow({Key? key}) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: _items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(right: 28),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 20, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_copies, (i) {
              if (i == 0) return _buildItemRow(key: _rowKey);
              return _buildItemRow();
            }),
          ),
        ),
      ),
    );
  }
}

class _BenefitItem {
  final IconData icon;
  final String label;

  const _BenefitItem(this.icon, this.label);
}
