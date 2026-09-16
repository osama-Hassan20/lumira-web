import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/responsive_helper/responsive_app_extensions.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../cubit/splash_cubit/splash_cubit.dart';

class SplashScreenAnimated extends StatefulWidget {
  const SplashScreenAnimated({super.key});

  @override
  State<SplashScreenAnimated> createState() => _SplashScreenAnimatedState();
}

class _SplashScreenAnimatedState extends State<SplashScreenAnimated>
    with TickerProviderStateMixin {
  // Controllers
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _versionController;
  late final AnimationController _pulseController;
  late final AnimationController _particleController;

  // Logo animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoRotation;

  // Subtitle / version
  late final Animation<double> _versionOpacity;
  late final Animation<Offset> _versionSlide;

  // Pulse glow
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    // ── Logo ──
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _logoRotation = Tween<double>(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // ── Version ──
    _versionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _versionOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _versionController, curve: Curves.easeIn),
    );
    _versionSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _versionController,
            curve: Curves.easeOutCubic,
          ),
        );

    // ── Pulse glow ──
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseScale = Tween<double>(
      begin: 0.8,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(
      begin: 0.3,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    // ── Particles ──
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
  }

  void _startSequence() async {
    // Step 1: Logo drops in with elastic bounce + rotation
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Step 2: Pulse glow behind logo
    await Future.delayed(const Duration(milliseconds: 600));
    _pulseController.repeat();
    _particleController.repeat();

    // Step 3: Text slides in
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Step 4: Version fades in
    await Future.delayed(const Duration(milliseconds: 600));
    _versionController.forward();

    // Step 5: Navigate after splash
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      SplashCubit.get(context).checkSavedData();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _versionController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = context.withFormFactor(
      onMobile: 100.0,
      onTablet: 130.0,
      onDesktop: 160.0,
    );
    final titleFontSize = context.withFormFactor(
      onMobile: 32.0,
      onTablet: 40.0,
      onDesktop: 48.0,
    );
    final versionFontSize = context.withFormFactor(
      onMobile: 13.0,
      onTablet: 15.0,
      onDesktop: 17.0,
    );

    return Container(
      color: AppColors.white,
      child: Stack(
        children: [
          // Floating particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) => CustomPaint(
              size: MediaQuery.sizeOf(context),
              painter: _ParticlePainter(
                progress: _particleController.value,
                color: AppColors.primary,
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Pulse glow behind logo ──
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) => Transform.scale(
                    scale: _pulseScale.value,
                    child: Opacity(
                      opacity: _pulseOpacity.value.clamp(0.0, 1.0),
                      child: Container(
                        width: logoSize * 1.5,
                        height: logoSize * 1.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withAlpha(40),
                              AppColors.primary.withAlpha(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Logo (overlaid on pulse position) ──
                Transform.translate(
                  offset: Offset(0, -(logoSize * 1.5) - 8),
                  child: AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) => Opacity(
                      opacity: _logoOpacity.value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: child,
                        ),
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.appLogo,
                      width: logoSize,
                      height: logoSize,
                    ),
                  ),
                ),

                // ── App name ──
                Transform.translate(
                  offset: Offset(0, -(logoSize * 1.5)),
                  child: FadeTransition(
                    opacity: _textController,
                    child: Text(
                      'A-to-Z New',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryA1A,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                // ── Version / subtitle ──
                Transform.translate(
                  offset: Offset(0, -(logoSize * 1.5) + 8),
                  child: SlideTransition(
                    position: _versionSlide,
                    child: FadeTransition(
                      opacity: _versionOpacity,
                      child: Text(
                        'Admin Dashboard  •  v1.0.1',
                        style: TextStyle(
                          fontSize: versionFontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary569,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom branding
          // Positioned(
          //   bottom: MediaQuery.paddingOf(context).bottom + 24,
          //   left: 0,
          //   right: 0,
          //   child: FadeTransition(
          //     opacity: _versionOpacity,
          //     child: Text(
          //       'Powered by MD Soft',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: AppColors.textSecondary569.withAlpha(120),
          //         fontWeight: FontWeight.w400,
          //         letterSpacing: 0.8,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// ─────────────────── Floating Particles Painter ───────────────────

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint();

    for (int i = 0; i < 20; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 0.3 + random.nextDouble() * 0.7;
      final radius = 1.5 + random.nextDouble() * 3.0;
      final phase = random.nextDouble() * math.pi * 2;

      final t = (progress * speed + phase / (math.pi * 2)) % 1.0;

      final x = baseX + math.sin(t * math.pi * 2 + phase) * 30;
      final y = baseY - t * size.height * 0.3;
      final opacity = (math.sin(t * math.pi) * 0.4).clamp(0.0, 1.0);

      paint.color = color.withAlpha((opacity * 80).round());
      canvas.drawCircle(Offset(x, y % size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
