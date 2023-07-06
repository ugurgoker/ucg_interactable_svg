import 'dart:ui';

class Region {
  final String id;
  final Path path;
  final String? title;
  final String pathString;
  final Color color;

  const Region({required this.id, required this.path, this.title, required this.pathString, required this.color});
}
