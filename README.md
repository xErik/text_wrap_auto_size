# text_wrap_auto_size

Wraps text and auto sizes it with respect to the given dimensions.

The text is never cut off. Insteads, it will apply the largest font size possible to fill the maximum of the available space.

Changing the text or changing the boundaries triggers a new layout cycle, thus adapting the text size dynamically.

Test the live demo [here](https://xerik.github.io/text_wrap_auto_size/).

## Requirements 

The widget **requires** a given width and height. It will throw an Exception, if it reveives an unbound (infinite) width or height. More about Flutter contraints [here](https://docs.flutter.dev/ui/layout/constraints).

## Usage

Generally, several Text attributes are respected, `style` probably being the most important one.

```dart
final style = TextStyle(
    fontWeight: FontWeight.bold, 
    color: Colors.red,
    fontFamiliy: 'Courier', // some fonts: strange results 
);

final text = Text(
    'text',
    style: style,
    textAlign: TextAlign.center,
    locale: Locale('en'),
    textScaleFactor: 1.0,
    semanticsLabel: 'semanticsLabel',
    strutStyle: StrutStyle(),
    textWidthBasis: TextWidthBasis.parent,
    textDirection: TextDirection.ltr,
    softWrap: true, // set to false for text on one line
    // maxLines: 2 <--- IGNORED !
);

TextWrapAutoSize(text);

// Or with automatic hyphenation:

TextWrapAutoSizeHyphend(text,'en_us');
```

### Use As Method

The static method `solution` allows for accessing the resulting font size directly, which resides in the `TextStyle`. Using this result, one can construct a font size adjusted widget manually.

```dart
Solution sol = TextWrapAutoSize.solution(Size size, Text text);

// Or with automatic hyphenation:

Solution sol = TextWrapAutoSizeHyphend.solution(Size size, Text text, 'en_us');

// String text for easy reference.

print(sol.textString); // String 

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
    child: Text(sol.textString, style: sol.style),
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

// Or with hyphens:

SizedBox(
    width:250,
    height:250,
    child: TextWrapAutoSizeHyphend(Text('text'), 'en_us')
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

Render debug info.

```dart 
TextWrapAutoSize(
    Text('text'), 
    doShowDebug: true
)

TextWrapAutoSizeHyphend(Text('text'), 
    'en_us', 
    doShowDebug: true
)
```

## Alternatives

The package [auto_size_text](https://pub.dev/packages/auto_size_text) does something similar.

The package [magic_text](https://pub.dev/packages/magic_text) does something similar.

## Background 

Internally, the widget performs a binary-search for the optimal font size and renders the text multiple times in its own render-tree.

In my typical use cases, the widgets needs nine steps to find the optimal font size.

### Todo

* Clipping the text?
* Setting min and max sizes (depends on clipping)?

## Issues

Open an issue on [Github](https://github.com/xErik/text_wrap_auto_size/issues).