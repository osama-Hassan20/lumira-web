// تم تعليق هذا الملف - نستخدم رفع الصور فقط حالياً
/*
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../core/api/end_points.dart';
import '../../../core/utils/theme/app_colors.dart';
import 'video_preview_web_helper.dart'
    if (dart.library.io) 'video_preview_stub_helper.dart';

class VideoPreviewWidget extends StatefulWidget {
  const VideoPreviewWidget({
    super.key,
    required this.videoPath,
    this.videoBytes,
    this.isNetworkVideo = false,
    this.height = 200,
  });

  final String videoPath;
  final Uint8List? videoBytes;
  final bool isNetworkVideo;
  final double height;

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {
  Player? _player;
  VideoController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  final List<StreamSubscription> _subscriptions = [];
  String? _blobUrl;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _player = Player();
      _controller = VideoController(_player!);

      String videoSource;

      // Handle different video sources
      if (widget.videoBytes != null && kIsWeb) {
        // For web file preview, create a blob URL
        _blobUrl = createBlobUrl(widget.videoBytes!);
        videoSource = _blobUrl!;
      } else if (widget.isNetworkVideo) {
        // For network videos
        videoSource = "${EndPoints.baseVideoUrl}${widget.videoPath}";
      } else {
        // For local file path (desktop/mobile)
        videoSource = widget.videoPath;
      }

      // Open the video source
      await _player!.open(Media(videoSource), play: false);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions first
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Dispose player and controller
    // Note: player.dispose() is async but we cannot await in dispose().
    // We trigger it and let it complete in the background.
    final playerToDispose = _controller?.player;
    playerToDispose?.dispose().catchError((e) {
      debugPrint('Error disposing player: $e');
    });

    // Revoke blob URL if created
    if (_blobUrl != null && kIsWeb) {
      revokeBlobUrl(_blobUrl!);
    }

    _player = null;
    _controller = null;

    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.gray1D,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.red),
            const SizedBox(height: 8),
            Text(
              'فشل في تحميل الفيديو',
              style: AppFontStyle.regular14(context),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized || _player == null || _controller == null) {
      return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.gray28,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video Player
            Video(
              controller: _controller!,
              fit: BoxFit.cover,
              controls: NoVideoControls,
            ),
            // Play/Pause overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: StreamBuilder<bool>(
                  stream: _player!.stream.playing,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return InkWell(
                      onTap: () {
                        if (_player != null && mounted) {
                          _player!.playOrPause();
                        }
                      },
                      child: Container(
                        color: isPlaying ? Colors.transparent : Colors.black26,
                        child: Center(
                          child: Icon(
                            isPlaying
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Duration indicator
            Positioned(
              bottom: 8,
              right: 8,
              child: StreamBuilder<Duration>(
                stream: _player!.stream.duration,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(duration),
                      style: AppFontStyle.regular12(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
