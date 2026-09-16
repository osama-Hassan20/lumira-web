import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../cubit/splash_cubit/splash_cubit.dart';

class SplashScreenImage extends StatefulWidget {
  const SplashScreenImage({super.key});

  @override
  State<SplashScreenImage> createState() => _SplashScreenImageState();
}

class _SplashScreenImageState extends State<SplashScreenImage> {
  bool _hasFinished = false;
  bool _timerStarted = false;
  double _opacity = 0.0;
  double _scale = 0.95;
  bool _isHiding = false;

  void _startHide() {
    if (_isHiding || !mounted) return;
    _isHiding = true;
    setState(() {
      _opacity = 0.25;
      _scale = 0.95;
    });
    Future.delayed(const Duration(milliseconds: 700), _finish);
  }

  void _finish() {
    if (_hasFinished) return;
    _hasFinished = true;
    if (mounted) {
      context.read<SplashCubit>().checkSavedData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          child: Image.asset(
            AppAssets.splash,
            // width: double.infinity,
            fit: BoxFit.contain,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame != null && !_timerStarted) {
                _timerStarted = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  setState(() {
                    _opacity = 1.0;
                    _scale = 1.0;
                  });
                });
                Future.delayed(const Duration(milliseconds: 2000), _startHide);
              }
              return child;
            },
          ),
        ),
      ),
    );
  }
}
