import 'package:flutter/material.dart';

class FadeTransitionAnimation extends StatefulWidget {
  const FadeTransitionAnimation({
    super.key,
    required this.child,
    required this.duration,
    this.curve,
  });

  final Widget child;
  final Duration duration;
  final Curve? curve;

  @override
  State<FadeTransitionAnimation> createState() =>
      _FadeTransitionAnimationState();
}

class _FadeTransitionAnimationState extends State<FadeTransitionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeIn,
    );
    // تأخير بدء الأنيميشن حتى بعد اكتمال بناء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
