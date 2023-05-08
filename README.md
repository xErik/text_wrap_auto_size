# text_wrap_auto_size

Wraps text and auto sizes it with respect to the given space.

Changing the text or changing the boundaries triggers a new layout cycle, thus adapting the text size dynamically.

![](screen-capture.gif)

## Requirements 

The widget requires a given width and height. 

It will throw an Exception, if it reveives an unbound (infinite) width or height.

More about Flutter contraints [here](https://docs.flutter.dev/ui/layout/constraints).

## Usage

Generally, the `TextStyle` is respected.

```dart
final style = TextStyle(
    fontWeight: FontWeight.bold, 
    color: Colors.red);

final text = Text('text', style: style);

TextWrapAutoSize(text);
````

Define width and height.

```dart
SizedBox(
    width:250,
    height:250,
    child: TextWrapAutoSize(Text('text'))
);
```

In some case, width and height can be determined by wrapping the widget in `Expanded`.

```dart
Expanded(
    child: TextWrapAutoSize(Text('text'))
);
```

Use it as the `Scaffold`'s body:

```dart
@override
Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        body: TextWrapAutoSize(Text('text')),
        ),
    );
}
```

## Issues

The package follows the most simple apporach I could think of. There might be a more efficient approach.

Internally, the widget test-renders the text with different font-sizes, performing a binary-search.

Open an issue on [Github](https://github.com/xErik/text_wrap_auto_size/issues).