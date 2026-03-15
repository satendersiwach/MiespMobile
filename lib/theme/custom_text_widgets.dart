import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Unified styled text widget. Pass a [fontFamily] to switch fonts.
/// Supported: 'poppins' (default), 'inter', 'redHatDisplay', 'suranna'.
Text getStyledText({
  required String text,
  String fontFamily = 'poppins',
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.center,
  int? maxLines,
  TextDecoration? decoration,
  double? lineSpace,
  Color color = Colors.black,
}) {
  final style = _getTextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    decoration: decoration,
    color: color,
    height: lineSpace,
  );
  return Text(text, textAlign: textAlign, maxLines: maxLines, style: style);
}

TextStyle _getTextStyle({
  required String fontFamily,
  double? fontSize,
  FontWeight? fontWeight,
  TextDecoration? decoration,
  Color? color,
  double? height,
}) {
  switch (fontFamily) {
    case 'inter':
      return GoogleFonts.inter(
          fontSize: fontSize, fontWeight: fontWeight, decoration: decoration, color: color, height: height);
    case 'redHatDisplay':
      return GoogleFonts.redHatDisplay(
          fontSize: fontSize, fontWeight: fontWeight, decoration: decoration, color: color, height: height);
    case 'suranna':
      return GoogleFonts.suranna(
          fontSize: fontSize, fontWeight: fontWeight, decoration: decoration, color: color, height: height);
    case 'poppins':
    default:
      return GoogleFonts.poppins(
          fontSize: fontSize, fontWeight: fontWeight, decoration: decoration, color: color, height: height);
  }
}

// Convenience aliases for backward compatibility
Text getPoppinsText({
  required text,
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.center,
  int? maxLines,
  TextDecoration? decoration,
  Color color = Colors.black,
}) =>
    getStyledText(
        text: text, fontFamily: 'poppins', fontSize: fontSize, fontWeight: fontWeight,
        textAlign: textAlign, maxLines: maxLines, decoration: decoration, color: color);

Text getInterText({
  required text,
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.center,
  int? maxLines,
  TextDecoration? decoration,
  double? lineSpace,
  Color color = Colors.black,
}) =>
    getStyledText(
        text: text, fontFamily: 'inter', fontSize: fontSize, fontWeight: fontWeight,
        textAlign: textAlign, maxLines: maxLines, decoration: decoration, lineSpace: lineSpace, color: color);

Text getRedHatDisplayText({
  required text,
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.center,
  int? maxLines,
  TextDecoration? decoration,
  double? lineSpace,
  Color color = Colors.black,
}) =>
    getStyledText(
        text: text, fontFamily: 'redHatDisplay', fontSize: fontSize, fontWeight: fontWeight,
        textAlign: textAlign, maxLines: maxLines, decoration: decoration, lineSpace: lineSpace, color: color);

TextSpan getPoppinsTextSpanHeading({
  required text,
  double fontSize = 13.0,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.center,
  int? maxLines,
  Color color = Colors.black,
}) {
  text += '   :  ';
  return TextSpan(
    text: text,
    style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  );
}

TextSpan getPoppinsTextSpanDetails({
  required text,
  double? fontSize = 12.0,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.center,
  int? maxLines,
  Color color = Colors.black,
}) {
  return TextSpan(
    text: text,
    style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text getCustomTextRich({required String heading, required String value}) {
  return Text.rich(
    TextSpan(children: [
      getPoppinsTextSpanHeading(text: heading),
      getPoppinsTextSpanDetails(text: value),
    ]),
  );
}

Text getHeadingText({
  required text,
  TextAlign textAlign = TextAlign.start,
  double fontSize = 13.0,
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.bold,
  int? maxLines,
  TextDecoration? decoration,
}) {
  return getPoppinsText(
      text: text, fontWeight: fontWeight, fontSize: fontSize,
      textAlign: textAlign, color: color, decoration: decoration, maxLines: maxLines);
}

Text getSubHeadingText({
  required text,
  TextAlign textAlign = TextAlign.start,
  int? maxLines,
  double fontSize = 12,
  Color color = Colors.black,
}) {
  return getPoppinsText(text: text, fontSize: fontSize, textAlign: textAlign, color: color, maxLines: maxLines);
}
