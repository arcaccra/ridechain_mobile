import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool expandable;
  final VoidCallback? onTap;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final Function()? onEditingComplete;
  final bool defaultValidation;

  const CustomTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.expandable = false,
    this.onTap,
    this.onEditingComplete,
    this.autovalidateMode,
    this.hintText,
    this.onChanged,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.inputFormatters,
    this.validator,
    this.defaultValidation = true,
  });

  @override
  Widget build(BuildContext context) {
    final _focusNode = FocusNode();
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 1),
      borderRadius: BorderRadius.circular(8.r),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: _focusNode,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: expandable ? 5 : 1,
      minLines: expandable ? 5 : 1,
      onTap: onTap,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: "Inter",
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.48,
        height: 1.2,
      ),
      cursorColor: AppColors.primaryColor,
      onTapOutside: (_) => _focusNode.unfocus(),
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        border: border,
        filled: true,
        fillColor: AppColors.white,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        hintText: hintText,
        labelText: null,
        errorBorder: border,
        errorStyle: TextStyle(
          fontSize: 14.sp,
          fontFamily: "Inter",
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.48,
          height: 1.2,
        ),
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontFamily: "Inter",
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.48,
          height: 1.2,
        ),
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontFamily: "Inter",
          color: AppColors.textFieldHintColor,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.48,
          height: 1.2,
        ),
        prefix: prefix,
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      inputFormatters: inputFormatters,
      validator: defaultValidation
          ? (value) {
        if (value == null || value.isEmpty) {
          return 'Required Field';
        }
        return validator?.call(value);
      }
          : validator,
    );
  }
}