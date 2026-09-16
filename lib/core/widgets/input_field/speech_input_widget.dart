// import 'package:doctor_station_user/core/widgets/input_field/full_name_input_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import '../../../config/app_constants.dart';
// import '../../../core/animations/slide_transition_animation.dart';
// import '../../../core/extensions/localization_extension.dart';
// import '../../../core/helpers/app_toast.dart';
// import '../../../core/utils/theme/app_colors.dart';
// import '../../../core/storage/shared_prefs.dart';
// import '../../../core/utils/constants/app_strings.dart';
// import '../../../core/widgets/custom_text_field.dart';

// class SpeechInputWidget extends StatefulWidget {
//   const SpeechInputWidget({
//     super.key,
//     required this.controller,
//     this.title,
//     this.hintText,
//     this.onChanged,
//     this.maxLines = 4,
//   });

//   final TextEditingController controller;
//   final String? title;
//   final String? hintText;
//   final ValueChanged<String>? onChanged;
//   final int maxLines;

//   @override
//   State<SpeechInputWidget> createState() => _SpeechInputWidgetState();
// }

// class _SpeechInputWidgetState extends State<SpeechInputWidget> {
//   late SpeechToText _speech;
//   bool _isListening = false;
//   String _sessionBase = '';
//   String _currentChunk = '';
//   String? _activeLocaleId;

//   @override
//   void initState() {
//     super.initState();
//     _speech = SpeechToText();
//   }

//   @override
//   void dispose() {
//     _isListening = false;
//     _speech.stop();
//     super.dispose();
//   }

//   Future<String?> _resolveLocaleId() async {
//     final savedLang =
//         SharedPrefHelper.getData(key: AppStrings.currentLanguage) as String?;
//     final targetLang = (savedLang != null && savedLang.isNotEmpty)
//         ? savedLang.split('-').first.toLowerCase()
//         : Localizations.localeOf(context).languageCode.toLowerCase();

//     final available = await _speech.locales();
//     final systemLocale = await _speech.systemLocale();

//     debugPrint('Target language: $targetLang');
//     debugPrint(
//       'Available locales: ${available.map((l) => l.localeId).join(', ')}',
//     );
//     debugPrint('System locale: ${systemLocale?.localeId}');

//     // ابحث عن locale يطابق اللغة المطلوبة
//     LocaleName? match;
//     for (final locale in available) {
//       if (locale.localeId.toLowerCase().startsWith(targetLang)) {
//         match = locale;
//         break;
//       }
//     }

//     if (match != null) {
//       debugPrint('Matched locale: ${match.localeId}');
//       return match.localeId;
//     }

//     // ✅ اللغة مش موجودة → أظهر رسالة واضحة وارجع null (من غير fallback)
//     if (mounted) {
//       ShowToast.showError(
//         messageTitle: targetLang == 'ar'
//             ? 'اللغة العربية غير مثبتة على الجهاز.\nيرجى تثبيتها من: إعدادات Windows ← Time & Language ← Speech'
//             : 'Language "$targetLang" is not available on this device.',
//       );
//     }

//     debugPrint('No matching locale found for: $targetLang — aborting.');
//     return null; // ✅ null = لا تبدأ التسجيل
//   }

//   void _updateController() {
//     final fullText = _currentChunk.isEmpty
//         ? _sessionBase
//         : (_sessionBase.isEmpty
//               ? _currentChunk
//               : '$_sessionBase $_currentChunk');

//     widget.controller.text = fullText;
//     widget.controller.selection = TextSelection.fromPosition(
//       TextPosition(offset: fullText.length),
//     );
//     widget.onChanged?.call(fullText);
//   }

//   void _startListeningSession(String localeId) {
//     if (!_isListening || !mounted) return;

//     _speech.listen(
//       onResult: (result) {
//         if (!mounted || !_isListening) return;

//         final recognized = result.recognizedWords.trim();
//         debugPrint('onResult: "$recognized" | final: ${result.finalResult}');

//         if (recognized.isEmpty) return;

//         if (result.finalResult) {
//           _sessionBase = _sessionBase.isEmpty
//               ? recognized
//               : '$_sessionBase $recognized';
//           _currentChunk = '';

//           _updateController();

//           // أعد تشغيل الـ listener بعد كل جملة مكتملة
//           if (_isListening && mounted) {
//             Future.delayed(
//               const Duration(milliseconds: 150),
//               () => _startListeningSession(localeId),
//             );
//           }
//         } else {
//           _currentChunk = recognized;
//           _updateController();
//         }
//       },
//       localeId: localeId,
//       partialResults: true,
//       listenMode: ListenMode.dictation,
//       pauseFor: const Duration(minutes: 30),
//       cancelOnError: false,
//       onSoundLevelChange: (level) {
//         debugPrint('Sound level: $level');
//       },
//     );
//   }

//   Future<void> _toggleListening() async {
//     if (!_isListening) {
//       // 1. تهيئة
//       try {
//         final available = await _speech.initialize(
//           onStatus: (status) {
//             debugPrint('Speech status: $status');
//           },
//           onError: (error) {
//             debugPrint('Speech error: ${error.errorMsg}');
//             if (mounted && _isListening && _activeLocaleId != null) {
//               if (error.errorMsg != 'error_audio') {
//                 Future.delayed(
//                   const Duration(milliseconds: 300),
//                   () => _startListeningSession(_activeLocaleId!),
//                 );
//               } else {
//                 setState(() => _isListening = false);
//               }
//             }
//           },
//         );

//         if (!available) {
//           ShowToast.showError(
//             messageTitle: 'لم يتم تفعيل خدمة التعرف على الكلام.',
//           );
//           return;
//         }
//       } on MissingPluginException {
//         ShowToast.showError(
//           messageTitle:
//               'خطأ في المكون الإضافي. حاول: flutter clean && flutter pub get',
//         );
//         return;
//       } catch (e) {
//         ShowToast.showError(messageTitle: e.toString());
//         return;
//       }

//       // 2. حدد الـ locale
//       final String? localeId;
//       try {
//         localeId = await _resolveLocaleId();
//       } catch (e) {
//         ShowToast.showError(
//           messageTitle: 'فشل تحديد لغة التعرف: ${e.toString()}',
//         );
//         return;
//       }

//       // ✅ لو اللغة مش موجودة، وقف هنا من غير ما تبدأ
//       if (localeId == null) return;

//       if (!mounted) return;

//       setState(() => _isListening = true);
//       _activeLocaleId = localeId;

//       // 3. ابدأ من النص الموجود
//       _sessionBase = widget.controller.text.trim();
//       _currentChunk = '';

//       // 4. ابدأ الاستماع
//       _startListeningSession(localeId);
//     } else {
//       // أوقف الاستماع
//       setState(() => _isListening = false);
//       _activeLocaleId = null;
//       await _speech.stop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isRtl = Directionality.of(context) == TextDirection.rtl;

//     return SlideTransitionAnimation(
//       duration: const Duration(
//         milliseconds:
//             AppConstants.animationDuration + AppConstants.animationIncrement,
//       ),
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//       curve: Curves.easeOutCubic,
//       child: Stack(
//         children: [
//           FullNameInputWidget(
//             controller: widget.controller,
//             title: widget.title,
//             hintText: widget.hintText,
//             onChanged: widget.onChanged,
//             maxLines: widget.maxLines,
//           ),
//           // Positioned(
//           //   left: isRtl ? 12 : null,
//           //   right: isRtl ? null : 12,
//           //   bottom: 12,
//           //   child: GestureDetector(
//           //     behavior: HitTestBehavior.opaque,
//           //     onTap: _toggleListening,
//           //     child: Container(
//           //       width: 42,
//           //       height: 42,
//           //       decoration: BoxDecoration(
//           //         color: _isListening ? AppColors.red : AppColors.grayEEF0FF,
//           //         borderRadius: BorderRadius.circular(12),
//           //       ),
//           //       alignment: Alignment.center,
//           //       child: Icon(
//           //         _isListening ? Icons.close : Icons.mic,
//           //         size: 20,
//           //         color: _isListening ? Colors.white : AppColors.primary,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
