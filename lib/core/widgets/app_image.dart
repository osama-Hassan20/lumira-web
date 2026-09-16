import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../api/end_points.dart';

/// نوع الصورة
enum ImageType { network, asset, file, svg }

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final ImageType? type;
  final String? baseUrl;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableShimmer;
  final BorderRadius borderRadius;
  final ImageFrameBuilder? frameBuilder;
  final ColorFilter? colorFilter;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.type,
    this.baseUrl,
    this.placeholder,
    this.errorWidget,
    this.enableShimmer = true,
    this.borderRadius = BorderRadius.zero,
    this.frameBuilder,
    this.colorFilter,
  });

  /// Constructor للصور من الإنترنت
  const AppImage.network({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.baseUrl,
    this.placeholder,
    this.errorWidget,
    this.enableShimmer = true,
    this.borderRadius = BorderRadius.zero,
    this.frameBuilder,
    this.colorFilter,
  }) : type = ImageType.network;

  /// Constructor للصور من الـ Assets
  const AppImage.asset({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.errorWidget,
    this.borderRadius = BorderRadius.zero,
    this.frameBuilder,
    this.colorFilter,
  }) : type = ImageType.asset,
       baseUrl = null,
       placeholder = null,
       enableShimmer = false;

  /// Constructor للصور من الملفات
  const AppImage.file({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.errorWidget,
    this.borderRadius = BorderRadius.zero,
    this.frameBuilder,
    this.colorFilter,
  }) : type = ImageType.file,
       baseUrl = null,
       placeholder = null,
       enableShimmer = false;

  /// Constructor لصور SVG
  const AppImage.svg({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.errorWidget,
    this.borderRadius = BorderRadius.zero,
    this.frameBuilder,
    this.colorFilter,
  }) : type = ImageType.svg,
       baseUrl = null,
       placeholder = null,
       enableShimmer = false;

  @override
  Widget build(BuildContext context) {
    try {
      final imageType = type ?? _detectImageType();

      Widget image = switch (imageType) {
        ImageType.network => _buildNetworkImage(context),
        ImageType.svg => _buildSvgImage(),
        ImageType.file => _buildFileImage(),
        ImageType.asset => _buildAssetImage(),
      };

      if (borderRadius != BorderRadius.zero) {
        return ClipRRect(borderRadius: borderRadius, child: image);
      }
      return image;
    } catch (e) {
      debugPrint('AppImage Error: $e');
      return _buildErrorWidget();
    }
  }

  /// تحديد نوع الصورة تلقائياً
  ImageType _detectImageType() {
    if (path.isEmpty) return ImageType.asset;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return ImageType.network;
    }

    if (path.endsWith('.svg')) {
      return ImageType.svg;
    }

    if (path.startsWith('/') || path.contains('\\')) {
      return ImageType.file;
    }

    return ImageType.asset;
  }

  /// بناء صورة من الإنترنت
  /// بناء صورة من الإنترنت مع تحسين الأنيميشن والعرض
  Widget _buildNetworkImage(BuildContext context) {
    if (path.isEmpty) return _buildErrorWidget();

    final imageUrl = _buildNetworkUrl();
    final fullImageUrl = imageUrl.startsWith('http')
        ? imageUrl
        : EndPoints.baseImageUrl + imageUrl;

    return CachedNetworkImage(
      imageUrl: fullImageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      // 1. تحسين جودة الصورة وسرعة التحميل
      filterQuality: FilterQuality.low, // أسرع في التحميل المبدئي
      // 2. إضافة أنيميشن عند ظهور الصورة (الـ Fade)
      fadeInDuration: const Duration(milliseconds: 500),
      fadeInCurve: Curves.easeIn,

      // 3. التحكم في الـ Placeholder
      placeholder: (context, url) =>
          placeholder != null ? placeholder! : _buildShimmerPlaceholder(),

      // 4. التعامل الاحترافي مع الخطأ
      errorWidget: (context, url, error) {
        debugPrint('Image load error: $url - $error');
        return _buildErrorWidget();
      },

      // 5. استخدام imageBuilder لضمان تطبيق الخصائص بشكل صحيح
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : colorFilter,
            ),
          ),
        );
      },

      // 6. إدارة الكاش لتقليل استهلاك الذاكرة
      memCacheWidth: (width != null && width!.isFinite && width! > 0)
          ? (width! * RenderErrorBox.padding.left).toInt()
          : null,
      memCacheHeight: (height != null && height!.isFinite && height! > 0)
          ? (height! * RenderErrorBox.padding.left).toInt()
          : null,
    );
  }

  /// بناء URL الصورة
  String _buildNetworkUrl() {
    String url = path.trim();

    // 1. التعامل مع الـ Base URL
    if (baseUrl != null && !url.startsWith('http')) {
      final cleanBaseUrl = baseUrl!.endsWith('/')
          ? baseUrl!.substring(0, baseUrl!.length - 1)
          : baseUrl;
      final cleanPath = url.startsWith('/') ? url.substring(1) : url;
      url = '$cleanBaseUrl/$cleanPath';
    }

    // 2. تنظيف الروابط ومنع التكرار (بدون تخريب البروتوكول)
    if (url.startsWith('http')) {
      // بنفصل البروتوكول (http://) عن باقي الرابط عشان ننظف الباقي براحتنا
      var parts = url.split('://');
      var protocol = parts[0];
      var remaining = parts.sublist(1).join('://');

      // بنشيل أي // مكررة في باقي الرابط
      remaining = remaining.replaceAll(RegExp(r'//+'), '/');
      url = '$protocol://$remaining';
    }

    return url;
  }

  /// بناء SVG
  Widget _buildSvgImage() {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
    );
  }

  /// بناء صورة من ملف
  Widget _buildFileImage() {
    final file = File(path);

    if (!file.existsSync()) {
      debugPrint('File not found: $path');
      return _buildErrorWidget();
    }

    return Image.file(
      file,
      width: width,
      height: height,
      color: color,
      frameBuilder: frameBuilder,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('File image error: $error');
        return _buildErrorWidget();
      },
    );
  }

  /// بناء صورة من Assets
  Widget _buildAssetImage() {
    if (path.endsWith('.svg')) {
      return _buildSvgImage();
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      color: color,
      fit: fit,
      frameBuilder: frameBuilder,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Asset image error: $error');
        return _buildErrorWidget();
      },
    );
  }

  /// Shimmer placeholder
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius, // استخدم الـ borderRadius الممرر للكلاس
        ),
      ),
    );
  }

  /// Error widget
  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: _calculateIconSize(width, height),
        color: Colors.grey[400],
      ),
    );
  }

  double _calculateIconSize(double? width, double? height) {
    double? minDim;
    if (width != null && width.isFinite && height != null && height.isFinite) {
      minDim = math.min(width, height);
    } else if (width != null && width.isFinite) {
      minDim = width;
    } else if (height != null && height.isFinite) {
      minDim = height;
    }

    if (minDim != null && minDim > 0 && minDim.isFinite) {
      final size = minDim * 0.4;
      return (size.isFinite && size > 0) ? size : 40;
    }
    return 40;
  }

  /// الحصول على ImageProvider
  ImageProvider getImageProvider() {
    final imageType = type ?? _detectImageType();

    return switch (imageType) {
      ImageType.network => CachedNetworkImageProvider(_buildNetworkUrl()),
      ImageType.file => FileImage(File(path)),
      ImageType.asset => AssetImage(path),
      ImageType.svg => throw UnsupportedError('SVG لا يدعم ImageProvider'),
    };
  }

  /// الحصول على DecorationImage
  DecorationImage getDecorationImage() {
    return DecorationImage(
      image: getImageProvider(),
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

/// Extension helper (اختياري - لو عايز تستخدم responsive sizing)
extension SizeExtension on BuildContext {
  double setWidth(double width) => width;
  double setHeight(double height) => height;
  double setMinSize(double size) => size;
  double setSp(double sp) => sp;
}
