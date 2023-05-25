# text_wrap_auto_size

Wraps text and auto sizes it with respect to the given dimensions, including style, text properties and correct hyphenation.

The text is never cut off. Insteads, it will apply the largest font size possible to fill the maximum of the available space. Changing the text or changing the boundaries triggers a new layout cycle, thus adapting the text size dynamically.

Test the live demo [live demo](https://xerik.github.io/text_wrap_auto_size/).

**Hyphenation**

This package uses [hyphenatorx](https://pub.dev/packages/hyphenatorx) for hyphenation based on `tex` defintions for various languages.

**Requirements**

The widget **requires** a given width and height. It will throw an Exception, if it reveives an unbound (infinite) width or height. More about Flutter contraints [here](https://docs.flutter.dev/ui/layout/constraints).

## Philosophy

`Text` and `TextStyle` contain all relevant properties. The widgets and method calls of this package accept a `Text` object and respect its `TextStyle`. 

## Usage

### Quickstart

Generally, several Text attributes are respected, `style` probably being the most important one. The attributes given below are not complete.

```dart
final style = TextStyle(
    fontWeight: FontWeight.bold, 
    color: Colors.red,
    fontFamiliy: 'Courier',  
    // ...
);

final text = Text(
    'text',
    style: style,
    textAlign: TextAlign.center,
    // ...
);

TextWrapAutoSize(text);

// Or with automatic hyphenation:

TextWrapAutoSizeHyphend(text,'en_us');
```

### Use As Method

The static method `solution` allows for accessing the computed data progrmmatically. The mmost important one is probably `TextStyle`, its `fontSize` set to the calculated font size. 

construct a font size adjusted widget manually or .

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

// Or use it as the `Scaffold`'s body, also allows for 
// correct determination of width and height.

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

Internally, the widget performs a binary-search for the optimal font size and renders the text multiple times in its own render-tree. In typical use cases, the widgets needs nine steps to find the optimal font size.

### Todo

* Clipping the text?
* Setting min and max sizes (depends on clipping)?

## Issues

Open an issue on [Github](https://github.com/xErik/text_wrap_auto_size/issues).