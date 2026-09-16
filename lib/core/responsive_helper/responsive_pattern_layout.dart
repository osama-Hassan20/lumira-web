import 'package:flutter/material.dart';

class ResponsivePatternLayout extends StatelessWidget {
  const ResponsivePatternLayout({
    super.key,
    required this.children,
    required this.patternBuilder,
    this.spacing = 8,
    this.rowSpacing = 8,
    this.padding,
    this.itemHeight,
    this.useFullScreenWidth = false,
  });

  final List<Widget> children;
  final List<int> Function(double width) patternBuilder;
  final double spacing;
  final double rowSpacing;
  final EdgeInsets? padding;
  final double? itemHeight;


  final bool useFullScreenWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        final double width = useFullScreenWidth
            ? MediaQuery.of(context).size.width
            : constraints.maxWidth;

        final pattern = patternBuilder(width);

        List<Widget> rows = [];
        int index = 0;

        for (final count in pattern) {
          if (index >= children.length) break;

          List<Widget> rowItems = [];

          for (int i = 0; i < count && index < children.length; i++) {
            final child = children[index++];
            rowItems.add(
              Expanded(
                child: itemHeight != null
                    ? SizedBox(height: itemHeight, child: child)
                    : child,
              ),
            );
          }

          rows.add(Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing, children: rowItems));
        }

        final content = Column(spacing: rowSpacing, children: rows);

        return padding != null
            ? Padding(padding: padding!, child: content)
            : content;
      },
    );
  }
}
