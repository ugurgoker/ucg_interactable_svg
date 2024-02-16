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
  final bool isMultiSelectable;
  final List<int> unSelectableIds;
  final Color? unSelectableColor;
  final String? unSelectableText;

  const UcgInteractableSvg(
      {Key? key,
      required this.svgAddress,
      required this.onChanged,
      this.width,
      this.height,
      this.selectedColor,
      this.isMultiSelectable = false,
      this.unSelectableIds = const [],
      this.unSelectableColor,
      this.unSelectableText})
      : super(key: key);

  @override
  UcgInteractableSvgState createState() => UcgInteractableSvgState();
}

class UcgInteractableSvgState extends State<UcgInteractableSvg> {
  final List<Region> _regionList = [];

  List<Region> selectedRegion = [];
  SizeController? _sizeController;
  Size? mapSize;

  @override
  void initState() {
    super.initState();
    Parser.refreshClass();
    SizeController.refreshClass();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRegionList();
    });
  }

  _loadRegionList() async {
    final list = await Parser.instance.svgToRegionList(widget.svgAddress, widget.unSelectableIds, widget.unSelectableText, widget.unSelectableColor);
    _sizeController = SizeController.instance;
    _regionList.clear();
    setState(() {
      _regionList.addAll(list);
      mapSize = _sizeController?.mapSize;
    });
  }

  void clearSelect() {
    setState(() {
      selectedRegion.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mapSize = _sizeController?.mapSize;
    return Row(
      children: [
        Container(width: mapSize == null ? 0 : mapSize.width >= size.width ? 20 : (size.width - mapSize.width) / 2.5),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (var region in _regionList) _buildStackItem(region),
            ],
          ),
        ),
        Container(width: mapSize == null ? 0 : mapSize.width >= size.width ? 20 : (size.width - mapSize.width) / 2.5),
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
        setState(() {});
      } else {
        if (widget.isMultiSelectable) {
          selectedRegion.add(region);
          setState(() {});
        } else {
          selectedRegion.clear();
          selectedRegion.add(region);
          setState(() {});
        }
      }
      widget.onChanged.call(region);
    });
  }
}
