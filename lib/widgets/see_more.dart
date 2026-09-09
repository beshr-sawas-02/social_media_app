import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  ExpandableText({required this.text, this.trimLines = 3});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorClickableText = Colors.blue;
    final widgetSpan = TextSpan(
      text: _isExpanded ? " See less" : " See more",
      style: TextStyle(color: colorClickableText),
      recognizer: TapGestureRecognizer()..onTap = _toggleExpanded,
    );

    final text = TextSpan(
      text: widget.text,
      style: TextStyle(color: Colors.black),
      children: [_isExpanded ? widgetSpan : null].whereType<TextSpan>().toList(),
    );

    return LayoutBuilder(
      builder: (context, size) {
        final textPainter = TextPainter(
          text: text,
          maxLines: _isExpanded ? null : widget.trimLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(minWidth: size.minWidth, maxWidth: size.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return RichText(text: text);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _isExpanded
                ? RichText(text: text)
                : RichText(
              text: TextSpan(
                text: widget.text.substring(
                  0,
                  textPainter.getPositionForOffset(
                    Offset(size.maxWidth, textPainter.height),
                  ).offset,
                ),
                style: TextStyle(color: Colors.black),
                children: [widgetSpan],
              ),
            ),
          ],
        );
      },
    );
  }
}
