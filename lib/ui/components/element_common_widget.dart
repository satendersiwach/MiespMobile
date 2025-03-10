import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';

Widget appVersionWidget() {
  return FutureBuilder(
      future: PackageInfo.fromPlatform(),

      builder: (context, snapshot) {
        if(!snapshot.hasData)
          {
            return const SizedBox(height: 0,width: 0,);
          }
        return Padding(
          padding: const EdgeInsets.only(top: 5.0,left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getPoppinsText(
                  text: 'Current app version : ',
                  color: appPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: getPoppinsText(
                    text:
                    ' ${snapshot.data?.version ?? ''} (${snapshot.data?.buildNumber ?? ''})',
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      });
}
