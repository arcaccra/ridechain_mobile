import 'dart:ui';

abstract class AppColors {

  static const primaryColor = Color(0xff101010);
  static const backgroundColor = Color(0xfff8f8ff);
  static const white = Color(0xffffffff);
  static const grey = Color(0xff6d7280);
  static const greyEd = Color(0xffededed);
  static const borderColor = Color(0xffececec);
  static const googleColour = Color(0xffeeeeee);
  static const textFieldBorderColor = Color(0xffe0e0e0);
  static const textFieldHintColor = Color(0xff828282);
  static const cancelButtonColor = Color(0xffe8eae9);

  static var gradientColors = [
    Color(0xff575757).withValues(alpha: 0.2),
    Color(0xffffffff),
  ];
}