import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../cubit/splash_cubit/splash_cubit.dart';

class SplashScreenVideo extends StatefulWidget {
  const SplashScreenVideo({super.key});

  @override
  State<SplashScreenVideo> createState() => _SplashScreenVideoState();
}

class _SplashScreenVideoState extends State<SplashScreenVideo> {
  late VideoPlayerController _controller;
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(AppAssets.splash);

    try {
      await _controller.initialize();
      if (!mounted) return;
      await _controller.setVolume(0.0);

      // تحديد نقطة النهاية عند 5 ثواني أو نهاية الفيديو (أيهما أقصر)
      final endPosition =
          _controller.value.duration < const Duration(milliseconds: 3600)
          ? _controller.value.duration
          : const Duration(milliseconds: 3600);

      _controller.addListener(() {
        if (_controller.value.position >= endPosition && !_hasFinished) {
          _finish();
        }
      });

      setState(() {});
      await _controller.play();
    } catch (e) {
      debugPrint("Error loading video: $e");
      _finish();
    }
  }

  void _finish() {
    if (_hasFinished) return;
    _hasFinished = true;

    // التأكد من أن الـ Cubit لا يتم استدعاؤه إلا إذا كان الـ Widget لا يزال موجوداً
    if (mounted) {
      context.read<SplashCubit>().checkSavedData();
    }
  }

  @override
  void dispose() {
    // التخلص من الـ controller فوراً لتجنب استهلاك الذاكرة
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const SizedBox.shrink(), // أو شعار بسيط (Logo) حتى يجهز الفيديو
    );
  }
}
