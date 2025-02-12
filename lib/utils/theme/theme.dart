import 'package:crumbles/utils/theme/custom%20themes/appbar_theme.dart';
import 'package:crumbles/utils/theme/custom%20themes/checkbox_theme.dart';
import 'package:crumbles/utils/theme/custom%20themes/elevated_button_theme.dart';
import 'package:crumbles/utils/theme/custom%20themes/outlined_button_theme.dart';
import 'package:crumbles/utils/theme/custom%20themes/text_field_theme.dart';
import 'package:crumbles/utils/theme/custom%20themes/text_theme.dart';
import 'package:flutter/material.dart';


class TAppTheme{
  TAppTheme._();
  static ThemeData lightTheme = ThemeData( 
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme, 
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckBoxTheme,
    outlinedButtonTheme: TOutlinedButtomTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,

  );
  static ThemeData DarkTheme = ThemeData( 
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme, 
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckBoxTheme,
    outlinedButtonTheme: TOutlinedButtomTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,

  );
}