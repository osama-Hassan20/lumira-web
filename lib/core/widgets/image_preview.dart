import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_image.dart';
import 'dart:ui';

import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';

class ImagePreview extends StatefulWidget {
  final List<String> networkUrls;
  final String title;
  final int? currIndex;
  const ImagePreview({
    super.key,
    required this.networkUrls,
    required this.title,
    this.currIndex,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final TransformationController _transformationController =
      TransformationController();
  final double _zoomScale = 3.0;
  late PageController _pageController;
  TapDownDetails? _doubleTapDetails;
  bool _showAppBar = true;
  int _currIndex = 0;

  void _handleDoubleTap() {
    final matrix = _transformationController.value;
    if (matrix != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      _transformationController.value = Matrix4.identity()
        ..translate(
          -position.dx * (_zoomScale - 1),
          -position.dy * (_zoomScale - 1),
        )
        ..scale(_zoomScale);
    }
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.currIndex ?? 0);
    super.initState();
    _currIndex = widget.currIndex ?? 0;
    _transformationController.addListener(_onTransformChange);
  }

  void _onTransformChange() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale <= 1.01 && !_showAppBar) {
      setState(() {
        _showAppBar = true;
      });
    } else if (scale > 1.01 && _showAppBar) {
      setState(() {
        _showAppBar = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.removeListener(_onTransformChange);
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
              title: Text(
                widget.title,
                style: AppFontStyle.regular14(
                  context,
                ).copyWith(color: AppColors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: AppColors.primary,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
            )
          : null,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          // Blurred background using current image
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage.network(
                  height: double.infinity,
                  width: double.infinity,
                  path: widget.networkUrls[_currIndex],
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(color: Colors.black.withValues(alpha: 0.3)),
                ),
              ],
            ),
          ),
          // Main image preview
          Hero(
            tag: widget.networkUrls,
            child: Center(
              child: GestureDetector(
                onDoubleTapDown: (details) => _doubleTapDetails = details,
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  maxScale: 12.0,
                  minScale: 1,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currIndex = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return AppImage.network(
                        height: double.infinity,
                        width: double.infinity,
                        path: widget.networkUrls[index],
                        fit: BoxFit.contain,
                      );
                    },
                    itemCount: widget.networkUrls.length,
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 50.0),
          //   child: CustomIndicatorRow(
          //     currIndex: _currIndex,
          //     sliderLength: widget.networkUrls.length,
          //   ),
          // ),
        ],
      ),
    );
  }
}
