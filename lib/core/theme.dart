

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

enum AppTheme {
  lightTheme, darkTheme
}

class AppThemes {
  static final appThemeData = {
    //create the dark theme
    //create the light theme
    AppTheme.darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColor.primaryColor,
          secondary: AppColor.primaryColor
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.primaryColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark
        ),
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      dividerColor: AppColor.borderColor,
      fontFamily: 'Geist',
    )
  };

  //---------------------------------------------------------------------------
  // appTheme constants

  //---------------------------------------------------------------------------
  //padding
  static const appPaddingSymmetricSmall = EdgeInsets.symmetric(horizontal: 8, vertical: 8);
  static const appPaddingSymmetricMedium = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  static const appPaddingSymmetricLarge = EdgeInsets.symmetric(horizontal: 16, vertical: 16);


  //---------------------------------------------------------------------------
  //text styles
  //
  static const appOutFitSmallStyle = TextStyle(fontSize: 12, fontFamily: "Outfit", color: AppColor.primaryColor);
  static const appOutFitSmallMedium = TextStyle(fontSize: 16, fontFamily: "Outfit", color: AppColor.primaryColor);
  static const appOutFitSmallLarge = TextStyle(fontSize: 20, fontFamily: "Outfit", color: AppColor.primaryColor);

  static const appBeauSansSmallStyle = TextStyle(fontSize: 12, fontFamily: "BeauSans", color: AppColor.primaryColor);
  static const appBeauSansSmallMedium = TextStyle(fontSize: 16, fontFamily: "BeauSans", color: AppColor.primaryColor);
  static const appBeauSansSmallLarge = TextStyle(fontSize: 20, fontFamily: "BeauSans", color: AppColor.primaryColor);

  static const appInterSmallStyle = TextStyle(fontSize: 12, fontFamily: "Inter", color: AppColor.primaryColor);
  static const appInterSmallMedium = TextStyle(fontSize: 16, fontFamily: "Inter", color: AppColor.primaryColor);
  static const appInterSmallLarge = TextStyle(fontSize: 20, fontFamily: "Inter", color: AppColor.primaryColor);

  //getCustomTextStyle
  static getCustomTextStyle(String? fontFamily, double? fontSize, Color? color, double? lineHeight) {
    return TextStyle(
      fontFamily: fontFamily ?? "BeauSans",
      color: color ?? AppColor.primaryColor,
      fontSize: fontSize ?? 16,
      height: lineHeight ?? 1
    );
  }

  //---------------------------------------------------------------------------
  //border styles
  static const appRoundedBorderSmall = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: AppColor.borderColor, width: 1)
  );

  //---------------------------------------------------------------------------
  //card styles
  static const appCardDecorationTheme = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(20.52)),
    color: AppColor.white
  );

  static BoxDecoration appCardDecorationWithShadowTheme = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(21.24)),
      boxShadow: [
        BoxShadow(
        offset: Offset(0, 3.27),
        blurRadius: 31.6,
        spreadRadius: 0,
        color: AppColor.primaryColor.withValues(alpha: 0.11),
      )],
      color: AppColor.white
  );

  //---------------------------------------------------------------------------
  //button styles
  static const buttonDecorationTheme = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(33.5)),
    color: AppColor.primaryColor,
  );

  static BoxDecoration buttonRoundedBorderDecorationTheme = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(33.5)),
    border: Border.all(width: 2, color: AppColor.primaryColor)
  );

}
