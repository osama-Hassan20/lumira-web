import 'package:flutter/material.dart';

Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required Widget child,
  Duration duration = const Duration(milliseconds: 350),
  Curve curve = Curves.easeOutBack,
  bool barrierDismissible = false,
  Color barrierColor = Colors.black54,
  String? barrierLabel,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel:
        barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    transitionDuration: duration,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final dialogBody = Center(
        child: GestureDetector(
          onTap: () {},
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(dialogContext).width - 6,
              ),
              child: _AnimatedDialogContent(
                animation: animation,
                curve: curve,
                child: child,
              ),
            ),
          ),
        ),
      );

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: barrierDismissible
            ? () => Navigator.of(dialogContext).pop()
            : null,
        child: SafeArea(child: dialogBody),
      );
    },
  );
}

class _AnimatedDialogContent extends StatelessWidget {
  const _AnimatedDialogContent({
    required this.animation,
    required this.curve,
    required this.child,
  });

  final Animation<double> animation;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        scale: curvedAnimation,
        child: RotationTransition(
          turns: Tween<double>(begin: 0.08, end: 0.0).animate(curvedAnimation),
          child: child,
        ),
      ),
    );
  }
}
