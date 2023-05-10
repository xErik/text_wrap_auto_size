# text_wrap_auto_size

Wraps text and auto sizes it with respect to the given space.

The text is never cut off. Insteads, it will apply the largest font size possible to fill the maximum of the available space.

Changing the text or changing the boundaries triggers a new layout cycle, thus adapting the text size dynamically.

Find a live example [here](https://xerik.github.io/text_wrap_auto_size/).

![](screen-capture.gif)

## Requirements 

The widget **requires** a given width and height. It will throw an Exception, if it reveives an unbound (infinite) width or height. More about Flutter contraints [here](https://docs.flutter.dev/ui/layout/constraints).

## Usage

Generally, several Text attributes are respected, `style` probably being the most important one.

```dart
final style = TextStyle(
    fontWeight: FontWeight.bold, 
    color: Colors.red,
    fontFamiliy: 'Courier',
);

final text = Text(
    'text',
    style: style,
    textAlign: TextAlign.center,
    locale: Locale('de'),
    textScaleFactor: 1.0,
    semanticsLabel: 'semanticsLabel',
    strutStyle: StrutStyle(),
    textWidthBasis: TextWidthBasis.parent,
    textDirection: TextDirection.ltr,
    softWrap: true, // set to false for text on one line
    // maxLines: 2 <--- IGNORED !
);

TextWrapAutoSize(text);
```

### Use As Method

The static method `solution` allows for accessing the resulting font size directly, which resides in the `TextStyle`. Using the result, one can construct a font size adjusted widget manually.

```dart
Solution sol = TextWrapAutoSize.solution(Size size, Text text);

// String text for easy reference.

print(sol.text); // String 

// TextStyle with adjusted font size.  
// All other style properties of the Text-parameter 
// are merged into it.

print(sol.style); // TextStyle 

// Resulting Size of the wrapped and auto sized text.
// Smaller or equal to the Size-parameter of the outer box.

print(sol.sizeInner); // Size

// The Size-parameter of the outer box for easy reference.

print(sol.sizeOuter); // Size

// How to output the font adjusted text yourself.

SizedBox(
    width: sol.sizeOuter.width,
    height: sol.sizeOuter.height,
    child: Text(sol.text, style: sol.style),
);
```

### Use As Widget



```dart
// Define width and height.

SizedBox(
    width:250,
    height:250,
    child: TextWrapAutoSize(Text('text'))
);

// In some cases, width and height can be determined 
// by wrapping the widget in `Expanded`.

Expanded(
    child: TextWrapAutoSize(Text('text'))
);

// Use it as the `Scaffold`'s body.

@override
Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: TextWrapAutoSize(Text('text')),
        ),
    );
}
```

## Alternatives

The package [auto_size_text](https://pub.dev/packages/auto_size_text) does something similar.

The package [magic_text](https://pub.dev/packages/magic_text) does something similar.

## Issues and Background

The package follows the most simple apporach I could think of. There might be a more efficient approach.

Internally, the widget performs a binary-search for the optimal font size and renders the text multiple times in its own render-tree.

In my typical use cases, the widgets needs nine steps to find the optimal font size.

The code measuring the widget size can be found in the [Flutter docs](https://api.flutter.dev/flutter/widgets/BuildOwner-class.html).

Open an issue on [Github](https://github.com/xErik/text_wrap_auto_size/issues).