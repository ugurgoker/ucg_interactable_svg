import 'dart:ui';
import 'models/region_area.dart';

class SizeController {
  static SizeController? _instance;

  static SizeController get instance {
    _instance ??= SizeController._init();
    return _instance!;
  }

  static void refreshClass() => _instance = null;

  SizeController._init();

  final RefionArea _regionArea = RefionArea();
  Size mapSize = Size.zero;

  void addBounds(Rect bound) {
    if (_regionArea.anyEmpty) {
      _regionArea
        ..minX = bound.left
        ..maxX = bound.right
        ..minY = bound.top
        ..maxY = bound.bottom;
    } else {
      if (bound.left < _regionArea.minX!) _regionArea.minX = bound.left;
      if (bound.right > _regionArea.maxX!) _regionArea.maxX = bound.right;
      if (bound.top < _regionArea.minY!) _regionArea.minY = bound.top;
      if (bound.bottom > _regionArea.maxY!) _regionArea.maxY = bound.bottom;
    }
    calculateArea();
  }

  void calculateArea() {
    if (_regionArea.anyEmpty) mapSize = Size.zero;

    double width = _regionArea.maxX! - _regionArea.minX!;
    double height = _regionArea.maxY! - _regionArea.minY!;

    mapSize = Size(width, height);
  }

  double calculateScale(Size? containerSize) {
    if (containerSize == null) {
      return 1.0;
    }

    Size? newContainerSize;

    double newWidth = 0, newHeight = 0;

    if (containerSize.aspectRatio < 1 && mapSize.aspectRatio > 1) {
      newWidth = containerSize.width;
      newHeight = newWidth * containerSize.width / containerSize.height;
      newContainerSize = Size(newWidth, newHeight);
      return newContainerSize.width / mapSize.width;
    }

    if (containerSize.aspectRatio < 1 && mapSize.aspectRatio < 1) {
      newHeight = containerSize.height;
      newWidth = newHeight * (mapSize.aspectRatio);
      newContainerSize = Size(newWidth, newHeight);
      return newContainerSize.height / mapSize.height;
    }

    newContainerSize = Size(newWidth, newHeight);

    // Scale for Responsive UI
    double scale1 = newContainerSize.width / mapSize.width;
    double scale2 = newContainerSize.height / mapSize.height;
    double mapScale = scale1 > scale2 ? scale1 : scale2;

    return mapScale;
  }

  double inverseOfScale(double scale) => 1.0 / scale;
}
