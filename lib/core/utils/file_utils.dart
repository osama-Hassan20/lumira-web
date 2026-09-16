String shortFileName(String? fileName) {
  if (fileName == null || fileName.isEmpty) return '-';

  final parts = fileName.split('-');
  if (parts.length < 3) return fileName;

  final secondLast = parts[parts.length - 2];
  final last = parts.last;

  final isNumericSuffix = RegExp(r'^\d+$').hasMatch(secondLast);
  final isTokenExt = RegExp(r'^[a-zA-Z0-9]+\.[^\.]+$').hasMatch(last);

  if (isNumericSuffix && isTokenExt) {
    return parts.sublist(0, parts.length - 2).join('-');
  }

  return fileName;
}
