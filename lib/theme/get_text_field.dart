import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getTextField(
    {required TextEditingController controller,
    String? labelText,
    String? hintText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
    Function? onLookupPressed,
    bool enableLookup = false,
    bool disabled = false,
    TextDirection? textDirection,
    Color fillColor = Colors.white,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool readOnly = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    int? maxLines,
    int? maxLength,
    Function? onTap,
    IconButton? iconButton,
      EdgeInsets  contentPadding= const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),
    BorderRadius borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(33),
      bottomRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
    ),
    double labelFontSize = 12,
    FontWeight labelFontWeight = FontWeight.w500,
    Color labelColor = Colors.black,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
    double paddingBottom = 6.0,
    double paddingLeft = 8,
    double paddingRight = 8,
      InputBorder? disabledBorder,
    List<BoxShadow>? boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4.0,
        offset: Offset(2.0, 2.0),
      ),
    ],
      Color hintColor=const Color.fromRGBO(20, 60, 76, 0.60),
      double hintFontSize=16,
      FontWeight hintFontWeight=FontWeight.w500,
    TextInputType? keyboardType = TextInputType.text}) {
  if (disabled) {
    fillColor = const Color(0XFFF3ECE7);
    readOnly = true;
    onTap = () {
      CustomSnackBar.errorSnackBar('Uneditable');
    };
  }
  return Padding(
    padding: EdgeInsets.only(
      bottom: paddingBottom,
      left: paddingLeft,
      right: paddingRight,
    ),
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: fillColor,
        shape: BoxShape.rectangle,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: TextFormField(
        controller: controller,
        key: key,
        onChanged: (val) {
          if (onChanged != null) {
            onChanged(val);
          }
        },
        onTap: onTap != null ? onTap as Function() : null,
        obscureText: obscureText,
        validator: validator,
        readOnly: readOnly,
        inputFormatters: inputFormatters,

        decoration: InputDecoration(
          labelStyle: GoogleFonts.redHatDisplay(
              fontSize: labelFontSize,
              fontWeight: labelFontWeight,
              color: labelColor),
          filled: true,
          labelText: labelText,
          hintText: hintText,
          hintStyle: GoogleFonts.redHatDisplay(
              color: hintColor,
              fontSize: hintFontSize,
              fontWeight: hintFontWeight),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: contentPadding,
          fillColor: fillColor,
          disabledBorder: disabledBorder??OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.black, width: 0.1),
          ),
          focusedBorder: disabledBorder??OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.black, width: 0.1),
          ),
          border:disabledBorder?? OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.black, width: 0.1),
          ),
          enabledBorder: disabledBorder??OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide:const  BorderSide(color: Colors.black, width: 0.1),
          ),
          //fillColor: Colors.green
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        autofocus: false,
        style: GoogleFonts.redHatDisplay(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      ),
    ),
  );
}

Widget getDateTextField(
    {required TextEditingController controller,
    String? labelText,
    String? hintText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
    Function? onLookupPressed,
    bool enableLookup = false,
    TextDirection? textDirection,
    Color fillColor = Colors.white,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
      EdgeInsets  contentPadding= const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool readOnly = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    int? maxLines,
    int? maxLength,
    Function? onTap,
    IconButton? iconButton,
    List<BoxShadow>? boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4.0,
        offset: Offset(2.0, 2.0),
      ),
    ],
    BorderRadius borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(33),
      bottomRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
    ),
    double labelFontSize = 12,
    FontWeight labelFontWeight = FontWeight.w500,
    Color labelColor = Colors.black,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
    double paddingBottom = 6.0,
    double paddingLeft = 8,
    double paddingRight = 8,
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: paddingBottom,
      left: paddingLeft,
      right: paddingRight,
    ),
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: fillColor,
        shape: BoxShape.rectangle,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: TextFormField(
        controller: controller,
        onChanged: (val) {
          if (onChanged != null) {
            onChanged(val);
          }
        },
        onTap: onTap != null
            ? onTap as Function()
            : () async {
                await getDatePopup(
                    initialDate: controller.text.isNotEmpty
                        ? getDateFromString(controller.text)
                        : null,
                    onDatePicked: (String pickedDate) async {
                      // localCurrController.text = await getLocalDate(
                      //     getDateFromString(pickedDate)!);
                      // print(pickedDate);

                      if (onChanged != null) {
                        onChanged(pickedDate);
                      }
                    });
              },
        obscureText: obscureText,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelStyle: GoogleFonts.redHatDisplay(
              fontSize: labelFontSize,
              fontWeight: labelFontWeight,
              color: labelColor),
          filled: true,
          labelText: labelText,
          hintText: hintText,
          hintStyle: GoogleFonts.redHatDisplay(
              color: const Color.fromRGBO(20, 60, 76, 0.60),
              fontSize: 16,
              fontWeight: FontWeight.w500),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding:contentPadding,
          fillColor: fillColor,
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: fillColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: fillColor, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: fillColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: fillColor, width: 1),
          ),
          //fillColor: Colors.green
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.redHatDisplay(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      ),
    ),
  );
}

Widget getDisabledTextField(
    {required TextEditingController controller,
    String? labelText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
    TextDirection? textDirection,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    Function? onLookupPressed,
    bool enableLookup = false,
    int? maxLines,
    Function? onTap,
    int? maxLength,
    IconButton? iconButton,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
      EdgeInsets  contentPadding= const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),
    List<BoxShadow>? boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4.0,
        offset: Offset(2.0, 2.0),
      ),
    ],
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 6.0,
      left: 8,
      right: 8,
    ),
    child: Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                if (onChanged != null) {
                  onChanged(val);
                }
              },
              inputFormatters: inputFormatters,
              validator: validator,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
                filled: true,
                labelText: labelText,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                contentPadding:
                    contentPadding,

                //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                fillColor: const Color(0XFFF3ECE7),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: fillColor, width: 1),
                ),
                hoverColor: Colors.red,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: fillColor, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: fillColor, width: 1),
                ),
                //fillColor: Colors.green
              ),
              maxLines: maxLines,
              readOnly: true,
              onTap: onTap != null
                  ? onTap as Function()
                  : () {
                      CustomSnackBar.errorSnackBar('Uneditable');
                    },
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          enableLookup
              ? iconButton ??
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: fillColor,
                    ),
                    onPressed: onLookupPressed != null
                        ? onLookupPressed as Function()
                        : null,
                  )
              : iconButton ??
                  const IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: null,
                  )
        ],
      ),
    ),
  );
}

Widget getDisabledTextFieldWithoutLookup(
    {required TextEditingController controller,
    String? labelText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
    TextDirection? textDirection,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    Function? onLookupPressed,
    bool enableLookup = false,
    int? maxLines,
    Function? onTap,
    int? maxLength,
    IconButton? iconButton,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
      EdgeInsets  contentPadding= const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 6.0,
      left: 8,
      right: 8,
    ),
    child: Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                if (onChanged != null) {
                  onChanged(val);
                }
              },
              inputFormatters: inputFormatters,
              validator: validator,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
                filled: true,
                labelText: labelText,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                contentPadding:
                    contentPadding,

                //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                fillColor: const Color(0XFFF3ECE7),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: fillColor, width: 1),
                ),
                hoverColor: Colors.red,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: fillColor, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: fillColor, width: 1),
                ),
                //fillColor: Colors.green
              ),
              maxLines: maxLines,
              readOnly: true,
              onTap: onTap != null
                  ? onTap as Function()
                  : () {
                      CustomSnackBar.errorSnackBar('Uneditable');
                    },
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> getTimePopup({
  required BuildContext context,
  required TimeOfDay initialTime,
  required Function(String pickedTime) onTimePicked,
}) async {
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );
  if (pickedTime != null) {
    onTimePicked("${pickedTime.hour}:${pickedTime.minute}");
  }
}

FilteringTextInputFormatter getDecimalRegEx() {
  return FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*'));
}

TextInputType getDecimalKeyboardType() {
  return const TextInputType.numberWithOptions(decimal: true);
}

Future<void> getDatePopup({
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? helpText,
  required Function(String pickedDate) onDatePicked,
}) async {
  firstDate ??= DateTime(1960);
  lastDate ??= DateTime(2100);
  // String? code =
  //     LocalStorage.getInstance()?.localStorage?.getString(keyAppLocaleCode);
  // Locale locale = CustomLocale.toLocale('en_US');

  DateTime? picked = await showDatePicker(
      context: Get.context!,
      locale: Get.locale,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.grey,
            splashColor: Colors.black,
            colorScheme: const ColorScheme.light(
                primary: appPrimary,
                onSecondary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
                secondary: Colors.black),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const Text(""),
        );
      },
      // initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText);

  if (picked != null) {
    onDatePicked(getFormattedDate(picked));
  } else {
    return;
  }
}
