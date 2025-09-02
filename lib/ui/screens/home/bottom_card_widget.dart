import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ridex/services/widget_animations.dart';
import 'package:ridex/ui/shared_widgets/custom_textfield.dart';

import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../shared_widgets/default_button.dart';

class BottomCardWidget extends StatelessWidget {
  const BottomCardWidget({super.key, required this.onBtnTap, required this.locationController});

  final VoidCallback onBtnTap;
  final TextEditingController locationController;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.11),
              spreadRadius: 0,
              blurRadius: 13.4,
              offset: Offset(0, 3.27),)
          ]
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: locationController,
            hintText: "Where to?",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            validator: (value){
              if(value!.isEmpty){
                return "Please enter a valid destination/stop";
              }
              return null;
            },
          ),
          Gap(24.h),
          DefaultButton(
            onBtnTap: onBtnTap,
            btnText: Label.buttonContinueLabel,
            isIconPresent: false,
            btnColor: AppColors.primaryColor,
            btnTextColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
