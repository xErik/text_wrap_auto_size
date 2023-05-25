import 'package:flutter/material.dart';

class EditRow extends StatelessWidget {
  final TextEditingController controller;
  final Function funcSetAlign;
  final Function funcSetColor;
  final Function funcSetWeight;
  final Function funcSetHyphenation;
  final TextAlign align;
  final Color color;
  final FontWeight weight;
  final bool isHyphenation;

  const EditRow(
      this.controller,
      this.funcSetAlign,
      this.funcSetColor,
      this.funcSetWeight,
      this.funcSetHyphenation,
      this.align,
      this.color,
      this.weight,
      this.isHyphenation,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 16, children: [
      TextFormField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Enter some text'),
        autofocus: true,
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton<TextAlign>(
            value: align,
            items: const [
              DropdownMenuItem(value: TextAlign.left, child: Text('left')),
              DropdownMenuItem(value: TextAlign.center, child: Text('center')),
              DropdownMenuItem(value: TextAlign.right, child: Text('right')),
            ],
            onChanged: (TextAlign? value) =>
                value != null ? funcSetAlign.call(value) : null),
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton<Color>(
            value: color,
            items: const [
              DropdownMenuItem(value: Colors.red, child: Text('red')),
              DropdownMenuItem(value: Colors.yellow, child: Text('yellow')),
              DropdownMenuItem(value: Colors.blue, child: Text('blue')),
            ],
            onChanged: (Color? value) =>
                value != null ? funcSetColor.call(value) : null),
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton<FontWeight>(
            value: weight,
            items: const [
              DropdownMenuItem(value: FontWeight.w100, child: Text('100')),
              DropdownMenuItem(value: FontWeight.w400, child: Text('400')),
              DropdownMenuItem(value: FontWeight.w900, child: Text('900')),
            ],
            onChanged: (FontWeight? value) =>
                value != null ? funcSetWeight.call(value) : null),
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton<bool>(
            value: isHyphenation,
            items: const [
              DropdownMenuItem(value: true, child: Text('hyphens')),
              DropdownMenuItem(value: false, child: Text('no hyphens')),
            ],
            onChanged: (bool? value) =>
                value != null ? funcSetHyphenation.call(value) : null),
      ),
    ]);
  }
}
