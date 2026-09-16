import 'package:flutter/material.dart';

import '../../config/app_constants.dart';

/// Entrance animation direction
enum EntranceDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
  fadeIn,
  scale,
}

/// Animated entrance widget for smooth UI animations
class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final EntranceDirection direction;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double offset;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.direction = EntranceDirection.fadeIn,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
    this.offset = 50.0,
  });

  /// Slide from top with fade
  const AnimatedEntrance.fromTop({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
    this.offset = 50.0,
  }) : direction = EntranceDirection.fromTop;

  /// Slide from bottom with fade
  const AnimatedEntrance.fromBottom({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
    this.offset = 50.0,
  }) : direction = EntranceDirection.fromBottom;

  /// Slide from left with fade
  const AnimatedEntrance.fromLeft({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
    this.offset = 50.0,
  }) : direction = EntranceDirection.fromLeft;

  /// Slide from right with fade
  const AnimatedEntrance.fromRight({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
    this.offset = 50.0,
  }) : direction = EntranceDirection.fromRight;

  /// Fade in only
  const AnimatedEntrance.fadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOut,
    this.offset = 0.0,
  }) : direction = EntranceDirection.fadeIn;

  /// Scale with fade
  const AnimatedEntrance.scale({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutBack,
    this.offset = 0.0,
  }) : direction = EntranceDirection.scale;

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: _getBeginOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case EntranceDirection.fromTop:
        return Offset(0, -widget.offset / 100);
      case EntranceDirection.fromBottom:
        return Offset(0, widget.offset / 100);
      case EntranceDirection.fromLeft:
        return Offset(-widget.offset / 100, 0);
      case EntranceDirection.fromRight:
        return Offset(widget.offset / 100, 0);
      case EntranceDirection.fadeIn:
      case EntranceDirection.scale:
        return Offset.zero;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget animatedChild = FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        );

        if (widget.direction == EntranceDirection.scale) {
          animatedChild = ScaleTransition(
            scale: _scaleAnimation,
            child: animatedChild,
          );
        } else if (widget.direction != EntranceDirection.fadeIn) {
          animatedChild = SlideTransition(
            position: _slideAnimation,
            child: animatedChild,
          );
        }

        return animatedChild;
      },
    );
  }
}

/// Staggered list animation widget
class StaggeredAnimatedList extends StatefulWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final EntranceDirection direction;
  final Curve curve;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const StaggeredAnimatedList({
    super.key,
    required this.children,
    this.itemDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.direction = EntranceDirection.fromBottom,
    this.curve = Curves.easeOutCubic,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  State<StaggeredAnimatedList> createState() => _StaggeredAnimatedListState();
}

class _StaggeredAnimatedListState extends State<StaggeredAnimatedList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisAlignment: widget.mainAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: List.generate(widget.children.length, (index) {
        return AnimatedEntrance(
          direction: widget.direction,
          delay: widget.itemDelay * 2,
          duration: widget.itemDuration,
          curve: widget.curve,
          child: widget.children[index],
        );
      }),
    );
  }
}

/// Grid item animated entrance
class AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final int index;
  final int crossAxisCount;
  final Duration baseDelay;
  final Duration itemDuration;
  final Curve curve;

  const AnimatedGridItem({
    super.key,
    required this.child,
    required this.index,
    this.crossAxisCount = 2,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.itemDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Calculate delay based on position
    final row = widget.index ~/ widget.crossAxisCount;
    final col = widget.index % widget.crossAxisCount;
    final delay = widget.baseDelay * (row + col);

    Future.delayed(delay, () {
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

/// Animated list item for ListView.builder and ListView.separated
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final Duration itemDuration;
  final Curve curve;
  final AnimatedListItemStyle style;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
    this.style = AnimatedListItemStyle.slideAlternate,
  });

  /// Slide from left
  const AnimatedListItem.fromLeft({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
  }) : style = AnimatedListItemStyle.slideLeft;

  /// Slide from right
  const AnimatedListItem.fromRight({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
  }) : style = AnimatedListItemStyle.slideRight;

  /// Slide from bottom
  const AnimatedListItem.fromBottom({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
  }) : style = AnimatedListItemStyle.slideBottom;

  /// Alternating left/right based on index
  const AnimatedListItem.alternate({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
  }) : style = AnimatedListItemStyle.slideAlternate;

  /// Scale with fade
  const AnimatedListItem.scale({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutBack,
  }) : style = AnimatedListItemStyle.scale;

  /// Fade only
  const AnimatedListItem.fade({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOut,
  }) : style = AnimatedListItemStyle.fade;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

enum AnimatedListItemStyle {
  slideLeft,
  slideRight,
  slideBottom,
  slideAlternate,
  scale,
  fade,
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  /// الحد الأقصى للـ index المستخدم في حساب التأخير
  /// العناصر بعد هذا الرقم تظهر كلها في نفس الوقت
  static const int _maxDelayIndex = 5;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.itemDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: _getBeginOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Calculate delay based on index — capped to prevent long waits
    final clampedIndex = widget.index.clamp(0, _maxDelayIndex);
    final delay = widget.baseDelay * clampedIndex;

    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Offset _getBeginOffset() {
    switch (widget.style) {
      case AnimatedListItemStyle.slideLeft:
        return const Offset(-0.3, 0);
      case AnimatedListItemStyle.slideRight:
        return const Offset(0.3, 0);
      case AnimatedListItemStyle.slideBottom:
        return const Offset(0, 0.3);
      case AnimatedListItemStyle.slideAlternate:
        return Offset(widget.index.isEven ? -0.3 : 0.3, 0);
      case AnimatedListItemStyle.scale:
      case AnimatedListItemStyle.fade:
        return Offset.zero;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = FadeTransition(opacity: _fadeAnimation, child: widget.child);

    if (widget.style == AnimatedListItemStyle.scale) {
      child = ScaleTransition(scale: _scaleAnimation, child: child);
    } else if (widget.style != AnimatedListItemStyle.fade) {
      child = SlideTransition(position: _slideAnimation, child: child);
    }

    return child;
  }
}

/// Animated horizontal list item
class AnimatedHorizontalListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final Duration itemDuration;
  final Curve curve;

  const AnimatedHorizontalListItem({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(
      milliseconds: AppConstants.animationIncrement,
    ),
    this.itemDuration = const Duration(
      milliseconds: AppConstants.animationDuration,
    ),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedHorizontalListItem> createState() =>
      _AnimatedHorizontalListItemState();
}

class _AnimatedHorizontalListItemState extends State<AnimatedHorizontalListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.itemDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0), // Slide from right for horizontal lists
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Calculate delay based on index
    final delay = widget.baseDelay * widget.index;

    Future.delayed(delay, () {
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
