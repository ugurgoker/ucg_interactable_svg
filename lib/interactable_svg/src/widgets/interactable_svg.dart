import 'package:flutter/material.dart';
import './region_painter.dart';
import '../models/region.dart';
import '../parser.dart';
import '../size_controller.dart';

class UcgInteractableSvg extends StatefulWidget {
  final double? width;
  final double? height;
  final String svgAddress;
  final Function(Region region) onChanged;
  final Color? selectedColor;
  final bool? isMultiSelectable;

  const UcgInteractableSvg({
    Key? key,
    required this.svgAddress,
    required this.onChanged,
    this.width,
    this.height,
    this.selectedColor,
    this.isMultiSelectable,
  }) : super(key: key);

  @override
  UcgInteractableSvgState createState() => UcgInteractableSvgState();
}

class UcgInteractableSvgState extends State<UcgInteractableSvg> {
  final List<Region> _regionList = [];

  List<Region> selectedRegion = [];
  final _sizeController = SizeController.instance;
  Size? mapSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRegionList();
    });
  }

  _loadRegionList() async {
    final list = await Parser.instance.svgToRegionList(widget.svgAddress);
    _regionList.clear();
    setState(() {
      _regionList.addAll(list);
      mapSize = _sizeController.mapSize;
    });
  }

  void clearSelect() {
    setState(() {
      selectedRegion.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var region in _regionList) _buildStackItem(region),
      ],
    );
  }

  Widget _buildStackItem(Region region) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () => toggleButton(region),
      child: CustomPaint(
        isComplex: true,
        size: Size(widget.width ?? mapSize?.width ?? 0, widget.height ?? mapSize?.height ?? 0),
        painter: RegionPainter(
          region: region,
          selectedRegion: selectedRegion,
          selectedColor: widget.selectedColor,
        ),
      ),
    );
  }

  void toggleButton(Region region) {
    setState(() {
      if (selectedRegion.contains(region)) {
        selectedRegion.remove(region);
      } else {
        if (widget.isMultiSelectable ?? false) {
          selectedRegion.add(region);
        } else {
          selectedRegion.clear();
          selectedRegion.add(region);
        }
      }
      widget.onChanged.call(region);
    });
  }
}
