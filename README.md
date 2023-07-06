# interactable SVG

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
import 'package:ucg_interactable_svg/ucg_interactable_svg/ucg_interactable_svg.dart';
```

## Usage

```dart
        InteractiveViewer(
          child:InteractableSvg(
            svgAddress: "<svg> </svg>",
            onChanged: (region) {
              setState(() {
                selectedRegion = region;
              });
            },
            width: double.infinity,
            height: double.infinity,
          ),
        )
```

Also your SVG must follow the following pattern.For better understanding see the example SVG.
```
'.* id="(.*)" name="(.*)" .* d="(.*)"'
for example:
  <path id="118" title="room 9" class="st0" d="M55 508h101.26v330H55Z" fill="#000000" style="fill:rgb(0, 0, 0)" />;

```
To select a region without clicking on the SVG see the below code.For better understanding check the example.
## Props
| props                   |           types            |                     description                      |
| :---------------------- |:--------------------------:|:----------------------------------------------------:|
| key        |           `Key?`           |                                                      |
| svgAddress       |          `String`          |    Address of an SVG like  svg tags    |
| width           |         `double?`          |     SVG width. Default value is double.infinity      |
| onChanged       | `Function(Region? region)` |       Returns new region value when it changed       |

Author
------

* [Uğur Can Göker](https://github.com/ugurgoker)
