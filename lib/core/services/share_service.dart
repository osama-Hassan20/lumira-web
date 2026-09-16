 
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

/// A reusable service for sharing content (text, images, widgets).
class ShareService {
  ShareService._();

  /// Share plain text with an optional subject.
  static Future<void> shareText({required String text, String? subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }

  /// Capture a widget via its [RepaintBoundary] key, then share as an image
  /// with an optional [text] message.
  static Future<void> shareWidget({
    required GlobalKey repaintBoundaryKey,
    String? text,
    double pixelRatio = 3.0,
  }) async {
    final boundary =
        repaintBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final pngBytes = byteData.buffer.asUint8List();

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        files: [
          XFile.fromData(pngBytes, mimeType: 'image/png', name: 'qr_code.png'),
        ],
      ),
    );
  }
}
