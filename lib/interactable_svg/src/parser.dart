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

  final sizeController = SizeController.instance;

  Parser._init();

  Future<List<Region>> svgToRegionList(String svg) async {
    List<Region> regionList = [];

    XmlDocument document = XmlDocument.parse(svg);
    var paths = document.findAllElements('path');
    var rects = document.findAllElements('rect');

    double width = 0;
    double height = 0;
    for (var element in rects) {
      width = double.tryParse(element.getAttribute('width').toString()) ?? 0;
      height = double.tryParse(element.getAttribute('height').toString()) ?? 0;
    }

    if (width == 0 || height == 0) {
      var svgs = document.findAllElements('svg');
      for (var element in svgs) {
        width = double.tryParse(element.getAttribute('width').toString()) ?? 0;
        height = double.tryParse(element.getAttribute('height').toString()) ?? 0;
      }
    }

    for (var element in paths) {
      String? partId = element.getAttribute('id')?.toString();
      String partPath = element.getAttribute('d').toString();
      String? title = element.getAttribute('title')?.toString();
      String? color = element.getAttribute('fill')?.toString();
      String? style = element.getAttribute('style')?.toString();

      Color c = Colors.black;
      if (color != null) {
        var colorCode = color;
        switch (colorCode) {
          case 'black':
            c = Colors.black;
            break;
          case 'white':
            c = Colors.white;
            break;
          default:
            c = Color(int.parse('0xFF${color.replaceAll('#', '')}'));
            break;
        }
      }
      if (style != null) {
        var rgbList = style.split('fill: rgb').last.replaceAll('(', '').replaceAll(';', '').replaceAll(')', '').replaceAll(' ', '').split(',');
        if (rgbList.length == 3) {
          c = Color.fromRGBO(int.tryParse(rgbList.first) ?? 0, int.tryParse(rgbList[1]) ?? 0, int.tryParse(rgbList.last) ?? 0, 1);
        }
      }

      var region = Region(id: partId ?? 'nullId', path: parseSvgPath(partPath), color: c, pathString: partPath, title: title);
      sizeController.addBounds(region.path.getBounds());
      regionList.add(region);
    }

    if (width > 0 && height > 0) {
      sizeController.mapSize = Size(width, height);
    }
    return regionList;
  }
}
