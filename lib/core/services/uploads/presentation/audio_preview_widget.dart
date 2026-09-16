// تم تعليق هذا الملف - نستخدم رفع الصور فقط حالياً
/*
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import '../../../core/utils/theme/app_colors.dart';

class AudioPreviewWidget extends StatefulWidget {
  const AudioPreviewWidget({
    super.key,
    required this.audioPath,
    required this.fileName,
    this.isNetworkAudio = false,
    this.fileSize,
  });

  final String audioPath;
  final String fileName;
  final bool isNetworkAudio;
  final String? fileSize;

  @override
  State<AudioPreviewWidget> createState() => _AudioPreviewWidgetState();
}

class _AudioPreviewWidgetState extends State<AudioPreviewWidget> {
  late final Player _player;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    // Listen to player state changes
    _player.stream.playing.listen((isPlaying) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    // Listen to errors
    _player.stream.error.listen((error) {
      if (mounted) {
        debugPrint('Audio player error: $error');
        ShowToast.showError(
          messageTitle: error.toString(),
        );
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_player.state.playing) {
        await _player.pause();
      } else {
        setState(() => _isLoading = true);
        if (_player.state.position == Duration.zero) {
          await _player.open(Media(widget.audioPath));
        } else {
          await _player.play();
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ShowToast.showError(messageTitle: e.toString());
         
      }
    }
  }

  Future<void> _seek(double value) async {
    final position = Duration(seconds: value.toInt());
    await _player.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grayE5,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Play/Pause Button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: StreamBuilder<bool>(
                  stream: _player.stream.playing,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      icon: _isLoading
                          ?   SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          : Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: AppColors.primary,
                              size: 32,
                            ),
                      onPressed: _isLoading ? null : _togglePlayPause,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // File Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fileName,
                      style: AppFontStyle.semiBold14(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600,color: AppColors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.audiotrack,
                          size: 14,
                          color: AppColors.grayAD,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.fileSize ?? '',
                          style: AppFontStyle.regular12(
                            context,
                          ).copyWith(color: AppColors.grayAD),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Column(
            children: [
              StreamBuilder<Duration>(
                stream: _player.stream.position,
                builder: (context, positionSnapshot) {
                  return StreamBuilder<Duration>(
                    stream: _player.stream.duration,
                    builder: (context, durationSnapshot) {
                      final position = positionSnapshot.data ?? Duration.zero;
                      final duration = durationSnapshot.data ?? Duration.zero;

                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.grayE5,
                              thumbColor: AppColors.primary,
                              overlayColor:
                                  AppColors.primary.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              value: position.inSeconds.toDouble(),
                              max: duration.inSeconds.toDouble() > 0
                                  ? duration.inSeconds.toDouble()
                                  : 1,
                              onChanged: _seek,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: AppFontStyle.regular12(
                                    context,
                                  ).copyWith(color: AppColors.grayAD),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: AppFontStyle.regular12(
                                    context,
                                  ).copyWith(color: AppColors.grayAD),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
