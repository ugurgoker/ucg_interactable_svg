# UCG Interactable SVG

A flutter package for interacting with different parts of an SVG.


## Getting Started

In the `pubspec.yaml` of your **Flutter** project, add the following dependency:

```yaml
dependencies:
  ...
  ucg_interactable_svg: any
```

In your library file add the following import:

```dart
import 'package:ucg_interactable_svg/interactable_svg/src/widgets/interactable_svg.dart';
```

## Usage

```dart
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: InteractiveViewer(
          child: UcgInteractableSvg(
            svgAddress: '<svg> </svg>',
            width: double.infinity,
            height: double.infinity,
            unSelectableColor: Colors.red,
            unSelectableText: 'this region is unselectable',
            unSelectableIds: const [118],
            selectedColor: Colors.black,
            isMultiSelectable: false,
            onChanged: (region) {
              if (region.title != null) {
                unawaited(showPlatformAlert(context, ModelAlertDialog(description: region.title!)));
                return;
              }
              if ((int.tryParse(region.id) ?? 0) != 0) {
                onSelected(int.tryParse(region.id) ?? 0);
              }
            },
            
          ),
        ),
      );
```

```
for svg path example:
  <path id="118" title="room 9" d="M55 508h101.26v330H55Z" fill="#000000" style="fill:rgb(0, 0, 0)" />;

```
To select a region without clicking on the SVG see the below code.For better understanding check the example.
## Props
| props                   |           types            |                     description                      |
| :---------------------- |:--------------------------:|:----------------------------------------------------:|
| key        |           `Key?`           |                                                      |
| svgAddress       |          `String`          |    Address of an SVG like  svg tags    |
| width           |         `double?`          |     SVG width. Default value is double.infinity      |
| onChanged       | `Function(Region region)` |       Returns new region value when it changed       |
| selectedColor       | `Color?` |       Selected svg path color       |
| isMultiSelectable       | `bool` |       Select more than one region default value is null       |
| unSelectableIds       | `List<int>` |       Select more than one region       |
| unSelectableColor       | `Color?` |       Disabled color for unselectable region       |
| unSelectableText       | `String?` |       The message you want returned to you in the title when clicked for the unselectable region       |


Author
------

* [Uğur Can Göker](https://github.com/ugurgoker)
