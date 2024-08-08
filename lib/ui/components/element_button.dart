
import 'package:flutter/material.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_text.dart';
import 'package:scanner/translations/custom_locale.dart';


Widget loadingButton(
    {required bool? isLoading,
    required String btnText,
    String? suffixText,
    required Function onPress,
    Color backColor = buttonColor,
    double rounded = 10,
    Color textColor = Colors.white,
      double fontSize=16,
      FontWeight fontWeight=FontWeight.w800,
    Key? key}) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Material(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(rounded)),
      elevation: 0.0,
      color: backColor,
      clipBehavior: Clip.antiAlias,
      // Add This
      child: MaterialButton(
        key: key,
        textColor: textColor,
        onPressed: onPress as Function(),
        splashColor: backColor,
        focusColor: backColor,
        elevation: 0.0,
        color: backColor,
        child: setUpButtonChild(
          isLoading ?? true,
          "${CustomLocale.text(btnText)} ${suffixText ?? ""}",
          textColor,
          fontSize: fontSize,
          fontWeight: fontWeight
        ),
      ),
    ),
  );
}

Widget setUpButtonChild(bool isLoading, String btnText, Color textColor,{
  double fontSize=16,
  FontWeight fontWeight=FontWeight.w600
}) {
  if (isLoading) {
    return SizedBox(
      height: 25.0,
      width: 25.0,
      child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(textColor)),
    );
  } else {
    return getRedHatDisplayText(
        text: btnText,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight);
    return textLabelRegularWithCustomSize(text: btnText, color: textColor);
  }
}

Widget textWithLoader(bool isLoading, Widget textWidget,
    {Color loaderColor = white, double size = 13.0, double width = 60}) {
  if (isLoading) {
    return SizedBox(
      height: size,
      width: width,
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
              strokeWidth: size / 8,
              valueColor: AlwaysStoppedAnimation<Color>(loaderColor)),
          height: size,
          width: size,
        ),
      ),
    );
  } else {
    return textWidget;
  }
}

Widget outlineButtonWidget(String text, Function onPressed,
    {EdgeInsets margin = const EdgeInsets.all(15.0),
    bool isDisable = false,
    bool expanded = true}) {
  var button = Container(
    margin: margin,
    height: 50,
    child: OutlinedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(isDisable ? Colors.grey : appAccent),
        shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      ),
      onPressed: isDisable ? null : onPressed as void Function()?,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            textLabelCenterAligned(
                text: text, //TGLocale.text(BEGIN_EXAM),
                size: 16,
                color: Colors.black)
          ],
        ),
      ),
    ),
  );
  if (expanded) {
    return Expanded(child: button);
  }
  return button;
}

IconButton getIconButton({
  IconData? icon,
  required Function onPressed,
  Color? iconColor,
  ButtonStyle? style,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  double iconSize = 22.0,
}) {
  return IconButton(
      padding: padding,
      style: style,
      onPressed: onPressed as Function(),
      icon: getIcon(icon, iconColor: iconColor, iconSize: iconSize));
}

Icon getIcon(IconData? icon, {Color? iconColor, double iconSize = 22.0}) {
  return Icon(
    icon,
    color: iconColor,
    size: iconSize,
  );
}

// SvgPicture getSVGIconButton({required String path}) {
//   return SvgPicture.asset(path);
// }
//
// SvgPicture getSVGIcon({required String path, Color? color}) {
//   return SvgPicture.asset(
//     path,
//     color: color,
//   );
// }

Widget getDrawerItemButton(
    {IconData? leadingIcon,
    IconData? trailingIcon,
    required Function onPressed,
    Color? leadingIconColor,
    Color? trailingIconColor,
    double iconSize = 22.0,
    required String itemTitle}) {
  return ListTile(
    onTap: onPressed as Function(),
    title: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        CustomLocale.text(itemTitle),
        style: const TextStyle(color: Colors.white),
      ),
    ),
    leading: leadingIconColor != null
        ? getIcon(leadingIcon, iconColor: leadingIconColor, iconSize: iconSize)
        : null,
    trailing: trailingIcon != null
        ? getIcon(trailingIcon,
            iconColor: trailingIconColor, iconSize: iconSize)
        : null,
  );
}
