# text_wrap_auto_size

Wraps text and auto sizes it with respect to the given dimensions, including style, text properties and correct hyphenation.

* Scales font size of widget of automatically.
* Accessing the font size calculation programmatically.
* Hyphenation for various languages.
* Setting min font size and max font size.
* Binary search instead of linear search for best font size.

[Live demo here](https://xerik.github.io/text_wrap_auto_size/).

**Hyphenation**

[hyphenatorx](https://pub.dev/packages/hyphenatorx) does the hyphenation for various languages.

**Requirements**

The widget **requires** a given width and height. It will throw an Exception, if it reveives an unbound (infinite) width or height. More about Flutter contraints [here](https://docs.flutter.dev/ui/layout/constraints).

## Philosophy

`Text` and `TextStyle` contain all relevant properties. The widgets and method calls of this package accept a `Text` object and respect its `TextStyle`. 

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

TextWrapAutoSize(text, 
    minFontSize: 50, // optional 
    maxFontSize: 100, // optional
);

// Or with automatic hyphenation:

TextWrapAutoSizeHyphend(text,'en_us', 
    minFontSize: 50, // optional 
    maxFontSize: 100, // optional
);
```

**minFontSize and maxFontSize**

`minFontSize` and `maxFontSize` will never cut off (clip) the text. In case `minFontSize` or `maxFontSize` result
in a font size that does not render all the text, these parameters are ignored.

**Language codes**

Language codes available for hyphenation, based on `tex` codes: 

```dart
[af, as, bg, bn, ca, cop, cs, cy, da, de_1901, de_1996, de_ch_1901, el_monoton, el_polyton, en_gb, en_us, eo, es, et, eu, fi, fr, fur, ga, gl, grc, gu, hi, hr, hsb, hu, hy, ia, id, is, it, ka, kmr, kn, la_x_classic, la, lt, lv, ml, mn_cyrl_x_lmc, mn_cyrl, mr, mul_ethi, nb, nl, nn, or, pa, pl, pms, pt, rm, ro, ru, sa, sh_cyrl, sk, sl, sv, ta, te, th, tk, tr, uk, zh_latn_pinyin]
```

## Usage

### Function call

The static method `solution` allows for accessing the computed data progrmmatically. The mmost important one is probably `TextStyle`, its `fontSize` set to the calculated font size. 

```dart
Solution sol = TextWrapAutoSize.solution(
    Size size, Text text);

// Or with automatic hyphenation:

Solution sol = TextWrapAutoSizeHyphend.solution(
    Size size, Text text, 'en_us');

// String text for easy reference.

print(sol.textString); // String 

// Text with TextStyle set.

print(sol.textString); // Text 

// TextStyle with adjusted font size.  
// All other style properties of the Text-parameter 
// are merged into it.

print(sol.style); // TextStyle 

// Resulting Size of the wrapped and auto sized text.
// Smaller or equal to the Size-parameter of the outer box.

print(sol.sizeInner); // Size

// The Size-parameter of the outer box for easy reference.

print(sol.sizeOuter); // Size

// Whether the calculated font size fits the outer box.
// This should not happen, except the font size is `1` 
// and the text still does not fit the outer box.

print(sol.isValid);

// How to output the font adjusted text yourself.

SizedBox(
    width: sol.sizeOuter.width,
    height: sol.sizeOuter.height,
    child: sol.text,
);
```

In case the Widgets are placed inside a Container with a hard padding and the Text misbehaves, calculate a soft padding to avoid sudden jumps of the text. These jumps should not happen and are most likely caused by internal rounding. In the future, a padding-parameter will be added which takes care of that.

```dart
// PROBLEM
// The hard padding may let the Text misbehave,
// especially on dynamic resizing.

Container(
    padding: EdgeInsets.all(16),
    width: 100,
    height: 100,
    child: TextWrapAutoSize(Text('text')),
)

// SOLUTION
// Use a soft padding, which is blank space around
// the centered Text.

Size outerBox = Size(100, 100);
double textPadding = 16;

final outerBoxAdjusted = Size(
    outerBox.width - textPadding * 2,
    outerBox.height - textPadding * 2);

Solution sol = TextWrapAutoSize.solution(
    outerBoxAdjusted, text);

final text = Container(
    width: outerBox.width,
    height: outerBox.height,
    alignment: Alignment.center,
    child: sol.text,
);
```

### Widget

```dart
// Define width and height.

SizedBox(
    width:250,
    height:250,
    child: TextWrapAutoSize(Text('text'))
);

// With hyphens:

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

[auto_size_text](https://pub.dev/packages/auto_size_text) does something similar.

[magic_text](https://pub.dev/packages/magic_text) does something similar.

## Background 

Internally, the widget performs a binary-search for the optimal font size and renders the text multiple times in its own render-tree. In typical use cases, the widgets needs nine steps to find the optimal font size.

### Todo

* Clipping the text?
* Add soft-padding support to avoid jumpy text using hard paddings?
* Remodel interface.

## Issues

Open an issue on [Github](https://github.com/xErik/text_wrap_auto_size/issues).