import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/constants/app_assets.dart';
import 'custom_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    this.message = 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(AppAssets.error, width: 180, height: 180),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),

              CustomButton(title: 'إعادة المحاولة', onTap: onRetry ?? () {}),

              // ElevatedButton(
              //   onPressed: onRetry,
              //   child: const Text('إعادة المحاولة'),
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
