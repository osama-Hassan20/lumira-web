import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../utils/theme/app_colors.dart';

enum AppLottieName { loading, empty, noInternet, success }

//* تحويل Enum → String Asset Name بدون امتداد
extension AppLottieNameExt on AppLottieName {
  String get fileName => switch (this) {
    AppLottieName.loading => "loading",
    AppLottieName.empty => "empty",
    AppLottieName.noInternet => "no_internet",
    AppLottieName.success => "payment_success",
  };
}

/// Best Performance + Auto Visibility Pause (بملفات .json)
class AppLottieAnimation extends StatefulWidget {
  final AppLottieName name;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;

  const AppLottieAnimation({
    required this.name,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
  });

  @override
  State<AppLottieAnimation> createState() => _AppLottieAnimationState();
}

class _AppLottieAnimationState extends State<AppLottieAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isVisible = false;
  bool _isCompositionReady = false;

  String _resolvePath(BuildContext context) {
    final base = "assets/animations/";
    final fileName = widget.name.fileName;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHighDpi = MediaQuery.of(context).devicePixelRatio >= 3.0;

    // ترتيب الأولوية: dark@3x → dark → @3x → الأساسي
    if (isDark && isHighDpi) {
      return "$base${fileName}_dark@3x.json";
    } else if (isDark) {
      return "$base${fileName}_dark.json";
    } else if (isHighDpi) {
      return "$base$fileName@3x.json";
    } else {
      return "$base$fileName.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playIfNeeded() {
    if (!_isCompositionReady || !_isVisible || !mounted) return;

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String path = _resolvePath(context);

    return VisibilityDetector(
      key: ValueKey(path), // عشان يتعرف على التغيير لو الثيم اتغير
      onVisibilityChanged: (info) {
        if (!mounted) return;
        final visible = info.visibleFraction > 0.1;
        setState(() => _isVisible = visible);

        if (visible) {
          _playIfNeeded();
        } else {
          _controller.stop();
        }
      },
      child: Lottie.asset(
        path,
        controller: _controller,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        repeat: false, // احنا بنتحكم في الـ repeat بنفسنا
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          setState(() => _isCompositionReady = true);
          _playIfNeeded();
        },
        errorBuilder: (context, exception, stackTrace) {
          // لو الملف مش موجود → fallback UI
          return _FallbackAnimation(
            width: widget.width,
            height: widget.height,
            name: widget.name,
          );
        },
      ),
    );
  }
}

class _FallbackAnimation extends StatelessWidget {
  final double? width;
  final double? height;
  final AppLottieName name;

  const _FallbackAnimation({
    required this.width,
    required this.height,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget child;

    switch (name) {
      case AppLottieName.loading:
        child = SizedBox(
          width: width ?? 48,
          height: height ?? 48,
          child: const CircularProgressIndicator(strokeWidth: 3),
        );
      default:
        child = Icon(
          Icons.broken_image_outlined,
          size: (width ?? height ?? 80) * 0.6,
          color: AppColors.grey,
        );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }
}
