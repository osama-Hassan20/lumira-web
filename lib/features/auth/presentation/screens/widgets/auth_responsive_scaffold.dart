import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/animations/fade_transition_animation.dart';
import '../../../../../core/responsive_helper/responsive_app_extensions.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/theme/app_colors.dart';

class AuthResponsiveScaffold extends StatelessWidget {
  const AuthResponsiveScaffold({
    super.key,
    required this.child,
    this.showIllustration = true,
    this.contentPadding,
  });

  final Widget child;
  final bool showIllustration;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: isMobile
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: child,
              )
            : Row(
                children: [
                  // ─── Right: Login Form ───
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 48,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                  // ─── Left: Yellow Splash Panel ───
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: _SplashPanel(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// الجانب الأيسر الأصفر مع الانيميشن
// ─────────────────────────────────────────────────────────────────────────────
class _SplashPanel extends StatelessWidget {
  const _SplashPanel();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.5;
    return Container(
      color: AppColors.primary,
      child: Stack(
        children: [
          // Top-right decorative circle
          Positioned.directional(
            start: -width * 0.48,
            end: width * 0.52,
            top: 0,
            bottom: MediaQuery.sizeOf(context).height * 0.6,
            textDirection: TextDirection.ltr,
            child: FadeTransitionAnimation(
              duration: const Duration(milliseconds: 1250),
              child: SvgPicture.asset(
                AppAssets.logoSvgIcon,
                colorFilter: ColorFilter.mode(
                  AppColors.white.withValues(alpha: 0.15),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          // Bottom-left decorative circle
          Positioned.directional(
            end: -width * 0.52,
            start: width * 0.48,
            bottom: 0,
            top: MediaQuery.sizeOf(context).height * 0.6,
            textDirection: TextDirection.ltr,
            child: FadeTransitionAnimation(
              duration: const Duration(milliseconds: 1250),
              child: SvgPicture.asset(
                AppAssets.logoSvgIcon,
                colorFilter: ColorFilter.mode(
                  AppColors.white.withValues(alpha: 0.15),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          // Center animated logo
          Center(
            child: _SvgWaterFillAnimation(assetName: AppAssets.logoSvgIcon),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// أنيميشن ملء الماء للـ SVG
// ─────────────────────────────────────────────────────────────────────────────
class _SvgWaterFillAnimation extends StatefulWidget {
  final String assetName;
  final Duration duration;
  final Color? color;
  final double width;
  final double height;

  const _SvgWaterFillAnimation({required this.assetName})
    : height = 140,
      width = 140,
      duration = const Duration(seconds: 2),
      color = null;

  @override
  State<_SvgWaterFillAnimation> createState() => _SvgWaterFillAnimationState();
}

class _SvgWaterFillAnimationState extends State<_SvgWaterFillAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fillAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    Future.delayed(const Duration(milliseconds: 1250), () {
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
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _fillAnimation,
        builder: (context, child) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: _fillAnimation.value,
                child: SvgPicture.asset(
                  widget.assetName,
                  colorFilter: widget.color != null
                      ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                      : const ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                  width: widget.width,
                  height: widget.height,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
