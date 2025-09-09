import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ridex/ui/screens/auth/auth_widgets/get_user_image.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';

import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../app/theme.dart';
import '../../../providers/auth_provider.dart';
import '../../shared_widgets/custom_app_bar.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';

class ImageCaptureScreen extends StatelessWidget {
  const ImageCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthVm>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(20.h),
                const CustomLoginAppBar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Gap(20.h),
                          Text(Label.imageTitleLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 38, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                                begin: const Offset(0, -0.3),
                                end: const Offset(0, 0), // End at center
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(4.h),
                          Text(Label.imageMessageLabel, style: AppThemes.getCustomTextStyle(fontFamily: "Zain", weight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 16, lineHeight: 1.33), textAlign: TextAlign.center)
                              .animate(delay: 100.ms)
                              .slide(
                                begin: const Offset(0, -0.3),
                                end: const Offset(0, 0), // End at center
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fade(begin: 0, end: 1, duration: 600.ms),
                          Gap(0.15.sh),
                          GetUserImage(
                            imageFile: authVm.imageFile,
                            onCameraTap: () {
                              authVm.captureProfilePicture(context,
                                  source: ImageSource.camera);
                              Get.back();
                            },
                            onGalleryTap: () {
                              authVm.captureProfilePicture(context,
                                  source: ImageSource.gallery);
                              Get.back();
                            },
                          ),
                          Gap(30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Profile Picture ", style: AppThemes.getCustomTextStyle(
                                fontFamily: "BeauSans",
                                fontSize: 12,
                                weight: FontWeight.w300,
                              ),),
                              Text("Upload", style: AppThemes.getCustomTextStyle(
                                fontFamily: "BeauSans",
                                fontSize: 12,
                                weight: FontWeight.w600,
                              ),),
                            ],
                          ),
                          Gap(50.h),
                          DefaultButton(onBtnTap: () async {
                            if (authVm.imageFile != null) {
                              authVm.addToRegisterMap("avatar", authVm.selectedFile);
                              await authVm.register();
                            }
                          }, btnText: Label.submitLabel, isIconPresent: false, btnColor: AppColors.purple, btnTextColor: AppColors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(16.h),
                Gap(16.h),
              ],
            ),
            Visibility(
              visible: authVm.isLoading,
              child: const Loader(),
            )
          ],
        ),
      ),
    );
  }
}
