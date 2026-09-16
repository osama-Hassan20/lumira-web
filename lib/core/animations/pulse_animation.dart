import 'package:flutter/material.dart';
import 'dart:math' as math;

/// أنيميشن دوران مرة واحدة عند الظهور
/// مناسب للشعارات والأيقونات المميزة
class SpinOnceAnimation extends StatefulWidget {
  const SpinOnceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  State<SpinOnceAnimation> createState() => _SpinOnceAnimationState();
}

class _SpinOnceAnimationState extends State<SpinOnceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // لف حول المحور Y (يدور جوه الشاشة)
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(_animation.value * 2 * math.pi),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
