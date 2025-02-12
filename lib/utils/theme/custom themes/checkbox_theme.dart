import 'package:flutter/material.dart';

class TCheckboxTheme{
  TCheckboxTheme._(); // to avoid creating instances 


  //customizable light text theme

  static CheckboxThemeData lightCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
    } else{
      return Colors.black;
    }}),

    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
    } else{
      return Colors.transparent;
    }}),
  
  );


  //customizable light text theme

  static CheckboxThemeData darkCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
    } else{
      return Colors.black;
    }}),

    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
    } else{
      return Colors.transparent;
    }}),
  
  );


}