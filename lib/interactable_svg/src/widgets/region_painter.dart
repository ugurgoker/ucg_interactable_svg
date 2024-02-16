import 'package:flutter/material.dart';

import '../models/region.dart';
import '../size_controller.dart';

class RegionPainter extends CustomPainter {
  final Region region;
  final List<Region> selectedRegion;
  final Color? selectedColor;

  final sizeController = SizeController.instance;

  double _scale = 1.0;

  RegionPainter({
    required this.region,
    required this.selectedRegion,
    this.selectedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = region.color
      ..style = PaintingStyle.fill;

    final selectedPen = Paint()
      ..color = selectedColor ?? Colors.blue
      ..style = PaintingStyle.fill;

      _scale = sizeController.calculateScale(size);
    
    canvas.scale(_scale);

    if (selectedRegion.contains(region) && (int.tryParse(region.id) ?? 0) != 0) {
      canvas.drawPath(region.path, selectedPen);
    }

    canvas.drawPath(region.path, pen);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    double inverseScale = sizeController.inverseOfScale(_scale);
    return region.path.contains(position.scale(inverseScale, inverseScale));
  }
}
