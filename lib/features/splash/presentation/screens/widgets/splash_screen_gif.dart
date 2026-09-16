import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../cubit/splash_cubit/splash_cubit.dart';

class SplashScreenGif extends StatefulWidget {
  const SplashScreenGif({super.key});

  @override
  State<SplashScreenGif> createState() => _SplashScreenGifState();
}

class _SplashScreenGifState extends State<SplashScreenGif> {
  bool _isTimerStarted = false;
  final Duration _gifDuration = const Duration(milliseconds: 3600);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppImage(
        path: AppAssets.splash, // مسار الـ GIF من ملف الأصول
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          // إذا تم تحميل أول إطار ولم يبدأ التوقيت بعد
          if (frame != null && !_isTimerStarted) {
            _isTimerStarted = true;

            // نستخدم addPostFrameCallback للتأكد من انتهاء بناء الـ Widget
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(_gifDuration, () {
                if (context.mounted) {
                  context.read<SplashCubit>().checkSavedData();
                }
              });
            });
          }
          return child;
        },
      ),
    );
  }
}
