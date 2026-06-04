import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../app/theme.dart';
import '../../../../core/core_constants/colors.dart';

class OtpFields extends StatelessWidget {
  const OtpFields({super.key, required this.otpCtrl});

  final TextEditingController otpCtrl;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      controller: otpCtrl,
      autoFocus: true,
      textStyle: AppThemes.getCustomTextStyle(
        fontFamily: 'Inter',
        weight: FontWeight.w700,
        color: AppColors.primaryColor,
        fontSize: 20,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(14),
        fieldHeight: 56,
        fieldWidth: 48,
        // fill colours
        activeFillColor: const Color(0xFFEDE8FA),
        selectedFillColor: const Color(0xFFE0D8F5),
        inactiveFillColor: const Color(0xFFEDE8FA),
        // border colours — transparent so only fill shows
        activeColor: Colors.transparent,
        selectedColor: AppColors.purple,
        inactiveColor: Colors.transparent,
        errorBorderColor: Colors.transparent,
        disabledColor: Colors.transparent,
      ),
      enableActiveFill: true,
      onCompleted: (v) => debugPrint('OTP complete: $v'),
      beforeTextPaste: (text) => true,
    );
  }
}
