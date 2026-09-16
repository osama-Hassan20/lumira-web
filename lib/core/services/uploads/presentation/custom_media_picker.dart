// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import '../../../utils/constants/app_assets.dart';
// import '../../../utils/theme/app_colors.dart';
// import '../../../utils/theme/app_font_styles.dart';
// import '../../../widgets/app_image.dart';
// import 'media_type_model.dart';

// class CustomMediaPicker extends StatelessWidget {
//   const CustomMediaPicker({
//     super.key,
//     required this.onMediaPicked,
//     required this.category,
//   });

//   final void Function(MediaTypeModel? media) onMediaPicked;
//   final MediaCategory category;

//   static Future<MediaTypeModel?> pickMedia({
//     required MediaCategory category,
//     required List<String> allowedExtensions,
//   }) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: allowedExtensions,
//         withData: true,
//       );

//       if (result != null) {
//         final file = result.files.single;
//         return MediaTypeModel(
//           type: MediaTypeEnum.file,
//           path: file.path ?? '',
//           category: category,
//           filename: file.name,
//           fileSize: file.size,
//           fileBytes: file.bytes,
//         );
//       }
//     } catch (e) {
//       debugPrint('Error picking ${category.name}: $e');
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 8,
//         ).copyWith(bottom: 24),
//         decoration: const BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           spacing: 16,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const CloseButton(color: AppColors.white, onPressed: null),
//                 Text('اختر الوسائط', style: AppFontStyle.regular14(context)),
//                 const CloseButton(),
//               ],
//             ),

//             // Images Section
//             if (category == MediaCategory.image) ...[
//               Text('الصور', style: AppFontStyle.bold14(context)),
//               _MediaOption(
//                 icon: AppAssets.addPhotoIcon,
//                 label: 'اختيار صورة',
//                 fullWidth: true,
//                 onTap: () async {
//                   final result = await pickMedia(
//                     category: MediaCategory.image,
//                     allowedExtensions: [
//                       'jpg',
//                       'jpeg',
//                       'png',
//                       'gif',
//                       'webp',
//                       'bmp',
//                     ],
//                   );
//                   onMediaPicked(result);
//                 },
//               ),
//             ],

//             // تم تعليقهم - نستخدم رفع الصور فقط حالياً
//             // // Videos Section
//             // if (category == MediaCategory.video) ...[
//             //   const Divider(),
//             //   Text('المُقَرَّرات', style: AppFontStyle.bold14(context)),
//             //   _MediaOption(
//             //     icon: AppAssets.addPhotoIcon,
//             //     label: 'اختيار مقطع فيديو',
//             //     fullWidth: true,
//             //     onTap: () async {
//             //       final result = await pickMedia(
//             //         category: MediaCategory.video,
//             //         allowedExtensions: ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'],
//             //       );
//             //       onMediaPicked(result);
//             //     },
//             //   ),
//             // ],

//             // // Audio Section
//             // if (category == MediaCategory.audio) ...[
//             //   const Divider(),
//             //   Text('الصوت', style: AppFontStyle.bold14(context)),
//             //   _MediaOption(
//             //     iconData: Icons.audiotrack,
//             //     label: 'اختيار صوت',
//             //     onTap: () async {
//             //       final result = await pickMedia(
//             //         category: MediaCategory.audio,
//             //         allowedExtensions: ['mp3', 'wav', 'm4a', 'ogg', 'aac'],
//             //       );
//             //       onMediaPicked(result);
//             //     },
//             //     fullWidth: true,
//             //   ),
//             // ],

//             // // Documents Section
//             // if (category == MediaCategory.document) ...[
//             //   const Divider(),
//             //   Text('المستندات', style: AppFontStyle.bold14(context)),
//             //   _MediaOption(
//             //     iconData: Icons.description,
//             //     label: 'اختيار مستند',
//             //     onTap: () async {
//             //       final result = await pickMedia(
//             //         category: MediaCategory.document,
//             //         allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
//             //       );
//             //       onMediaPicked(result);
//             //     },
//             //     fullWidth: true,
//             //   ),
//             // ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MediaOption extends StatelessWidget {
//   const _MediaOption({
//     this.icon,
//     required this.label,
//     required this.onTap,
//     this.fullWidth = false,
//   });

//   final String? icon;
//   final String label;
//   final VoidCallback onTap;
//   final bool fullWidth;

//   @override
//   Widget build(BuildContext context) {
//     final child = InkWell(
//       onTap: onTap,
//       child: Column(
//         spacing: 5,
//         children: [
//           if (icon != null)
//             AppImage.svg(
//               path: icon!,
//               width: 50,
//               colorFilter: ColorFilter.mode(AppColors.grayAD, BlendMode.srcIn),
//             ),
//           Text(label, style: AppFontStyle.regular14(context)),
//         ],
//       ),
//     );

//     if (fullWidth) {
//       return SizedBox(
//         width: double.infinity,
//         child: Center(child: child),
//       );
//     }

//     return child;
//   }
// }
