// import 'package:flutter/material.dart';

// import 'package:image/image.dart' as img;
// import '../../../helpers/app_toast.dart';
// import '../../../utils/constants/app_assets.dart';
// import '../../../utils/theme/app_colors.dart';
// import '../../../utils/theme/app_font_styles.dart';
// import '../../../widgets/app_image.dart';
// import '../../../widgets/dashed_border_container.dart';
// import 'custom_box_validator.dart';
// import 'custom_media_picker.dart';
// import 'media_type_model.dart';
// // تم تعليقهم - نستخدم رفع الصور فقط حالياً
// // import 'video_preview_widget.dart';
// // import 'audio_preview_widget.dart';
// // import 'document_preview_widget.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:async';
// import 'dart:convert';

// // Conditional imports for web
// import 'package:universal_html/html.dart' as html;

// class CustomAddMedia extends StatefulWidget {
//   const CustomAddMedia({
//     super.key,
//     this.initialMedia,
//     this.onChanged,
//     this.headerText,
//     this.headerTextStyle,
//     this.enableValidator = true,
//     this.category = MediaCategory.image,
//     this.emptyStateTitle,
//     this.emptyStateDescription,
//     this.customLoadingWidget,
//   });

//   final MediaTypeModel? initialMedia;
//   final String? headerText;
//   final TextStyle? headerTextStyle;
//   final ValueChanged<MediaTypeModel?>? onChanged;
//   final bool enableValidator;
//   final MediaCategory category;
//   final String? emptyStateTitle;
//   final String? emptyStateDescription;
//   final Widget? customLoadingWidget;

//   @override
//   State<CustomAddMedia> createState() => _CustomAddMediaState();
// }

// class _CustomAddMediaState extends State<CustomAddMedia> {
//   MediaTypeModel? mediaModel;
//   bool _isCompressing = false;

//   @override
//   void initState() {
//     super.initState();
//     mediaModel = widget.initialMedia;
//   }

//   @override
//   void didUpdateWidget(CustomAddMedia oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.initialMedia != oldWidget.initialMedia) {
//       setState(() {
//         mediaModel = widget.initialMedia;
//       });
//     }
//   }

//   Future<void> _handleMediaPicked(
//     MediaTypeModel? value,
//     void Function(MediaTypeModel?)? didChange,
//   ) async {
//     if (value != null) {
//       final int sizeInBytes = value.fileSize ?? 0;
//       final double sizeInMB = sizeInBytes / (1024 * 1024);

//       if (value.category == MediaCategory.image) {
//         if (sizeInMB > 50) {
//           if (!mounted) return;
//           ShowToast.showError(
//             messageTitle: "حجم الصورة يجب أن لا يتجاوز 50 ميجابايت",
//           );
//           return;
//         }
//       } else {
//         if (sizeInMB > 5) {
//           if (!mounted) return;
//           ShowToast.showError(
//             messageTitle: "حجم الملف يجب أن لا يتجاوز 5 ميجابايت",
//           );
//           return;
//         }
//       }

//       // Compress image if it's an image file
//       if (value.category == MediaCategory.image) {
//         setState(() {
//           _isCompressing = true;
//         });

//         try {
//           final compressed = await _compressImage(value);
//           if (compressed != null) {
//             value = compressed;
//           }
//         } catch (e) {
//           debugPrint("Error compressing image: $e");
//         }

//         if (!mounted) return;
//         setState(() {
//           _isCompressing = false;
//         });
//       }

//       setState(() => mediaModel = value);
//       didChange?.call(value);
//       widget.onChanged?.call(value);
//     }
//   }

//   Future<MediaTypeModel?> _compressImage(MediaTypeModel model) async {
//     if (model.fileBytes == null && model.path.isEmpty) return null;

//     Uint8List? originalBytes = model.fileBytes;

//     try {
//       final Uint8List inputBytes;
//       if (originalBytes != null) {
//         inputBytes = originalBytes;
//       } else {
//         return model;
//       }

//       debugPrint(
//         'Original image size: ${(inputBytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(2)} MB',
//       );

//       // Use different compression strategy based on platform
//       final compressedBytes = kIsWeb
//           ? await _compressImageWeb(inputBytes)
//           : await compute(_compressImageTask, inputBytes);

//       if (compressedBytes != null) {
//         debugPrint(
//           'Compressed image size: ${(compressedBytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(2)} MB',
//         );
//         return model.copyWith(
//           fileBytes: compressedBytes,
//           fileSize: compressedBytes.length,
//           mimeType: 'image/jpeg',
//           filename: model.filename != null
//               ? ('${model.filename!.replaceAll(RegExp(r'\.[^.]+$'), '')}_compressed.jpg')
//               : 'compressed_image.jpg',
//         );
//       }
//     } catch (e) {
//       debugPrint("Compression failed: $e");
//     }

//     return model;
//   }

//   // Web-specific compression using HTML Canvas API (non-blocking)
//   Future<Uint8List?> _compressImageWeb(Uint8List bytes) async {
//     try {
//       // Create a blob from the bytes
//       final blob = html.Blob([bytes]);
//       final url = html.Url.createObjectUrlFromBlob(blob);

//       // Create an image element
//       final img = html.ImageElement();
//       final completer = Completer<html.ImageElement>();

//       img.onLoad.listen((event) {
//         completer.complete(img);
//       });

//       img.onError.listen((event) {
//         completer.completeError('Failed to load image');
//       });

//       img.src = url;

//       // Wait for image to load
//       await completer.future;

//       // Calculate new dimensions
//       int targetWidth = img.width!;
//       int targetHeight = img.height!;

//       if (targetWidth > 1920) {
//         final ratio = 1920 / targetWidth;
//         targetWidth = 1920;
//         targetHeight = (targetHeight * ratio).round();
//       }

//       // Create canvas and draw resized image
//       final canvas = html.CanvasElement(
//         width: targetWidth,
//         height: targetHeight,
//       );
//       final ctx = canvas.context2D;

//       ctx.drawImageScaled(img, 0, 0, targetWidth, targetHeight);

//       // Convert canvas to base64 data URL
//       final dataUrl = canvas.toDataUrl('image/jpeg', 0.85);

//       // Convert base64 to Uint8List
//       // Data URL format: "data:image/jpeg;base64,....."
//       final base64String = dataUrl.split(',').last;

//       // We need to decode base64.
//       final result = base64Decode(base64String);

//       // Clean up
//       html.Url.revokeObjectUrl(url);

//       return result;
//     } catch (e) {
//       debugPrint("Web compression failed: $e");
//       return null;
//     }
//   }

//   Future<void> _pickMedia(void Function(MediaTypeModel?)? didChange) async {
//     final enabledCategories = [
//       if (widget.category == MediaCategory.image) MediaCategory.image,
//       if (widget.category == MediaCategory.video) MediaCategory.video,
//       if (widget.category == MediaCategory.audio) MediaCategory.audio,
//       if (widget.category == MediaCategory.document) MediaCategory.document,
//     ];

//     if (enabledCategories.length == 1) {
//       final category = enabledCategories.first;
//       List<String> extensions = [];
//       switch (category) {
//         case MediaCategory.image:
//           extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
//           break;
//         case MediaCategory.video:
//           extensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'];
//           break;
//         case MediaCategory.audio:
//           extensions = ['mp3', 'wav', 'm4a', 'ogg', 'aac'];
//           break;
//         case MediaCategory.document:
//           extensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'];
//           break;
//       }
//       final result = await CustomMediaPicker.pickMedia(
//         category: category,
//         allowedExtensions: extensions,
//       );
//       _handleMediaPicked(result, didChange);
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return CustomMediaPicker(
//             category: widget.category,
//             onMediaPicked: (value) {
//               Navigator.of(context).pop();
//               _handleMediaPicked(value, didChange);
//             },
//           );
//         },
//       );
//     }
//   }

//   void _deleteMedia(void Function(MediaTypeModel?)? didChange) {
//     setState(() => mediaModel = null);
//     didChange?.call(null);
//     widget.onChanged?.call(
//       MediaTypeModel(
//         type: MediaTypeEnum.network,
//         path: '',
//         category: widget.category,
//         isDeleted: true,
//       ),
//     );
//   }

//   Widget _buildMediaPreview(void Function(MediaTypeModel?)? didChange) {
//     if (mediaModel == null || mediaModel!.path.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     switch (mediaModel!.category) {
//       case MediaCategory.image:
//         return _buildImagePreview(didChange);
//       // تم تعليقهم - نستخدم رفع الصور فقط حالياً
//       // case MediaCategory.video:
//       //   return _buildVideoPreview(didChange);
//       // case MediaCategory.audio:
//       //   return _buildAudioPreview(didChange);
//       // case MediaCategory.document:
//       //   return _buildDocumentPreview(didChange);
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildImagePreview(void Function(MediaTypeModel?)? didChange) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child:
//               mediaModel!.type == MediaTypeEnum.file &&
//                   mediaModel!.fileBytes != null
//               ? Image.memory(
//                   mediaModel!.fileBytes!,
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                   // loading when image is loading
//                   frameBuilder:
//                       (context, child, frame, wasSynchronouslyLoaded) {
//                         if (frame == null) {
//                           return const SizedBox(
//                             width: double.infinity,
//                             height: 200,
//                             child: Center(child: CircularProgressIndicator()),
//                           );
//                         }
//                         return child;
//                       },
//                 )
//               : AppImage.network(
//                   path: mediaModel?.path ?? "",
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//         ),
//         const SizedBox(height: 8),
//         _buildActionButtons(didChange),
//       ],
//     );
//   }

//   // تم تعليقهم - نستخدم رفع الصور فقط حالياً
//   // Widget _buildVideoPreview(void Function(MediaTypeModel?)? didChange) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.end,
//   //     children: [
//   //       VideoPreviewWidget(
//   //         videoPath: mediaModel!.path,
//   //         videoBytes: mediaModel!.fileBytes,
//   //         isNetworkVideo: mediaModel!.type == MediaTypeEnum.network,
//   //         height: 200,
//   //       ),
//   //       const SizedBox(height: 8),
//   //       _buildActionButtons(didChange),
//   //     ],
//   //   );
//   // }

//   // Widget _buildAudioPreview(void Function(MediaTypeModel?)? didChange) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.end,
//   //     children: [
//   //       AudioPreviewWidget(
//   //         audioPath: mediaModel!.path,
//   //         fileName: mediaModel!.displayName,
//   //         isNetworkAudio: mediaModel!.type == MediaTypeEnum.network,
//   //         fileSize: mediaModel!.fileSizeFormatted,
//   //       ),
//   //       const SizedBox(height: 8),
//   //       _buildActionButtons(didChange),
//   //     ],
//   //   );
//   // }

//   // Widget _buildDocumentPreview(void Function(MediaTypeModel?)? didChange) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.end,
//   //     children: [
//   //       DocumentPreviewWidget(
//   //         fileName: mediaModel!.displayName,
//   //         filePath: mediaModel!.path,
//   //         fileSize: mediaModel!.fileSizeFormatted,
//   //       ),
//   //       const SizedBox(height: 8),
//   //       _buildActionButtons(didChange),
//   //     ],
//   //   );
//   // }

//   Widget _buildActionButtons(void Function(MediaTypeModel?)? didChange) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         TextButton(
//           onPressed: () => _pickMedia(didChange),
//           child: Row(
//             children: [
//               Text(
//                 'تغيير الصورة',
//                 style: AppFontStyle.regular14(
//                   context,
//                 ).copyWith(color: AppColors.primary),
//               ),
//               const SizedBox(width: 4),
//               AppImage.svg(
//                 path: AppAssets.editIcon,
//                 colorFilter: ColorFilter.mode(
//                   AppColors.primary,
//                   BlendMode.srcIn,
//                 ),
//                 width: 18,
//                 height: 18,
//               ),
//             ],
//           ),
//         ),
//         TextButton(
//           onPressed: () => _deleteMedia(didChange),
//           child: Row(
//             children: [
//               Text(
//                 'حذف الوسائط',
//                 style: AppFontStyle.regular14(
//                   context,
//                 ).copyWith(color: AppColors.red),
//               ),
//               const SizedBox(width: 4),
//               AppImage.svg(path: AppAssets.deleteIcon, width: 18, height: 18),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState(void Function(MediaTypeModel?)? didChange) {
//     String defaultTitle = 'اضغط لاضافة الوسائط هنا';
//     if (widget.category == MediaCategory.image) {
//       defaultTitle = 'اضغط لاضافة الصورة هنا';
//     } else if (widget.category == MediaCategory.video) {
//       defaultTitle = 'اضغط لاضافة الفيديو هنا';
//     } else if (widget.category == MediaCategory.audio) {
//       defaultTitle = 'اضغط لاضافة الصوت هنا';
//     } else if (widget.category == MediaCategory.document) {
//       defaultTitle = 'اضغط لاضافة المستند هنا';
//     }

//     return InkWell(
//       onTap: () => _pickMedia(didChange),
//       borderRadius: BorderRadius.circular(12),
//       child: DashedBorderContainer(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             widget.category == MediaCategory.image
//                 ? AppImage.svg(path: AppAssets.addPhotoIcon)
//                 : const SizedBox.shrink(),
//             widget.category == MediaCategory.video
//                 ? AppImage.svg(path: AppAssets.addPhotoIcon)
//                 : const SizedBox.shrink(),

//             const SizedBox(height: 4),

//             Text(
//               widget.emptyStateTitle ?? defaultTitle,
//               textAlign: TextAlign.center,
//               style: AppFontStyle.medium16(context),
//             ),

//             Text(
//               widget.emptyStateDescription ??
//                   '( يفضل حجم: 512x512 px – صيغة PNG أو JPG )',
//               textAlign: TextAlign.center,
//               style: AppFontStyle.semiBold14(
//                 context,
//               ).copyWith(color: AppColors.gray1D),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       spacing: 4,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.headerText != null)
//           Text(
//             widget.headerText!,
//             style:
//                 widget.headerTextStyle ??
//                 AppFontStyle.bold16(context).copyWith(fontSize: 16),
//           ),
//         CustomBoxValidator<MediaTypeModel?>(
//           context: context,
//           //autovalidate: true,
//           initialValue: mediaModel,
//           validator: (value) {
//             if ((value == null || value.path.isEmpty == true) &&
//                 widget.enableValidator) {
//               return 'الرجاء اضافة الوسائط';
//             }
//             return null;
//           },
//           builder: (state) {
//             if (_isCompressing) {
//               if (widget.customLoadingWidget != null) {
//                 return widget.customLoadingWidget!;
//               }
//               return DashedBorderContainer(
//                 child: SizedBox(
//                   height: 200,
//                   width: double.infinity,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const CircularProgressIndicator(),
//                       const SizedBox(height: 12),
//                       Text(
//                         'جاري معالجة الصورة...',
//                         style: AppFontStyle.regular14(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//             if (mediaModel?.path != null) {
//               return _buildMediaPreview(state.didChange);
//             } else {
//               return _buildEmptyState(state.didChange);
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

// // Native platform compression (runs in isolate)
// Future<Uint8List?> _compressImageTask(Uint8List bytes) async {
//   try {
//     final decoded = img.decodeImage(bytes);
//     if (decoded == null) return null;

//     var imageToProcess = decoded;
//     if (decoded.width > 1920) {
//       imageToProcess = img.copyResize(decoded, width: 1920);
//     }
//     return Uint8List.fromList(img.encodeJpg(imageToProcess, quality: 85));
//   } catch (e) {
//     debugPrint("Transform failure: $e");
//     return null;
//   }
// }
