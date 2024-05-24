import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:xml/xml.dart';

import './size_controller.dart';
import './models/region.dart';

class Parser {
  static Parser? _instance;

  static Parser get instance {
    _instance ??= Parser._init();
    return _instance!;
  }

  static void refreshClass() => _instance = null;

  final sizeController = SizeController.instance;

  Parser._init();

  Future<List<Region>> svgToRegionList(
    String svg,
    String? Function(int partId, String? defaultTitle)? pathTitle,
    Color? Function(int partId, Color? defaultColor)? pathColor,
  ) async {
    List<Region> regionList = [];

    XmlDocument document = XmlDocument.parse(svg);
    var paths = document.findAllElements('path');

    double width = 0;
    double height = 0;
    String viewBox = '';

    if (width == 0 || height == 0) {
      var svgs = document.findAllElements('svg');
      for (var element in svgs) {
        width = double.tryParse(element.getAttribute('width').toString()) ?? 0;
        height = double.tryParse(element.getAttribute('height').toString()) ?? 0;
        viewBox = element.getAttribute('viewBox').toString();
      }
    }

    for (var element in paths) {
      String? partId = element.getAttribute('id')?.toString();
      String partPath = element.getAttribute('d').toString();
      String? title = element.getAttribute('title')?.toString();
      String? style = element.getAttribute('style')?.toString();
      var color = element.getAttribute('fill')?.toString().toColor(style);
      var strokeColor = element.getAttribute('stroke').toColor(null);
      var strokeWidth = int.tryParse(element.getAttribute('stroke-width') ?? '');

      final integerPartId = int.tryParse(partId ?? '') ?? -1;
      if (integerPartId != -1 && pathColor != null) {
        color = pathColor(integerPartId, color) ?? color;
      }
      if (integerPartId != -1 && pathTitle != null) {
        title = pathTitle(integerPartId, title) ?? title;
      }

      var region = Region(
        id: partId ?? 'nullId',
        path: parseSvgPath(partPath),
        color: color ?? Colors.transparent,
        pathString: partPath,
        title: title,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      );
      sizeController.addBounds(region.path.getBounds());
      regionList.add(region);
    }

    if (viewBox.isNotEmpty && viewBox.split(' ').isNotEmpty) {
      height = double.tryParse(viewBox.split(' ')[3]) ?? 0;
      width = double.tryParse(viewBox.split(' ')[2]) ?? 0;
    }
    sizeController.mapSize = Size(width, height);
    return regionList;
  }
}

extension StringExtension on String? {
  Color toColor(String? style) {
    Color c = Colors.transparent;
    if (style != null) {
      var rgbList = style.split('fill: rgb').last.replaceAll('(', '').replaceAll(';', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      if (rgbList.length == 3) {
        c = Color.fromRGBO(int.tryParse(rgbList.first) ?? 0, int.tryParse(rgbList[1]) ?? 0, int.tryParse(rgbList.last) ?? 0, 1);
      }
    }
    if (this != null) {
      var colorCode = this;
      switch (colorCode) {
        case 'black':
          c = Colors.black;
          break;
        case 'white':
          c = Colors.white;
          break;
        default:
          c = Color(int.parse('0xFF${this!.replaceAll('#', '')}'));
          break;
      }
    }
    return c;
  }
}
