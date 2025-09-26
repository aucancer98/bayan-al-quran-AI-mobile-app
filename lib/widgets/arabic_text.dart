import 'package:flutter/material.dart';
import '../utils/rtl_utils.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const ArabicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = RTLUtils.isArabic(text);
    final fontFamily = RTLUtils.getFontFamily(text);
    final direction = RTLUtils.getTextDirection(text);
    final alignment = textAlign ?? RTLUtils.getTextAlign(text);

    return Directionality(
      textDirection: direction,
      child: Text(
        text,
        style: style?.copyWith(
          fontFamily: fontFamily,
        ) ?? TextStyle(
          fontFamily: fontFamily,
        ),
        textAlign: alignment,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
      ),
    );
  }
}

class ArabicRichText extends StatelessWidget {
  final List<TextSpan> children;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const ArabicRichText({
    super.key,
    required this.children,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if any of the children contain Arabic text
    final hasArabic = children.any((span) => 
      RTLUtils.isArabic(span.text ?? ''));
    
    final direction = hasArabic ? TextDirection.rtl : TextDirection.ltr;
    final alignment = textAlign ?? (hasArabic ? TextAlign.right : TextAlign.left);

    return Directionality(
      textDirection: direction,
      child: RichText(
        text: TextSpan(
          children: children.map((span) {
            final isArabic = RTLUtils.isArabic(span.text ?? '');
            final fontFamily = RTLUtils.getFontFamily(span.text ?? '');
            
            return TextSpan(
              text: span.text,
              style: span.style?.copyWith(
                fontFamily: fontFamily,
              ) ?? TextStyle(
                fontFamily: fontFamily,
              ),
              recognizer: span.recognizer,
            );
          }).toList(),
        ),
        textAlign: alignment,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.clip,
        softWrap: softWrap ?? true,
      ),
    );
  }
}
