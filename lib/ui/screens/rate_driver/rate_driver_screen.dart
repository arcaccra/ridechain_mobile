import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';
import 'package:ridex/ui/shared_widgets/custom_textfield.dart';

import '../../../app/theme.dart';
import '../../../core/core_constants/colors.dart';
import '../../../core/core_constants/label.dart';
import '../../../providers/rides_provider.dart';
import '../../shared_widgets/default_back_button.dart';
import '../../shared_widgets/default_button.dart';
import '../../shared_widgets/loader.dart';

class RateDriverScreen extends StatefulWidget {
  const RateDriverScreen({super.key});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  TextEditingController reviewController = TextEditingController();
  List<String> selectedSuggestion = [];
  String? selectedSuggestionText;

  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    return Container(
      height: 0.95.sh,
      width: 1.sw,
      decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(16),
              const Row(
                children: [
                  DefaultBackButton(
                    iconColor: AppColors.black,
                  ),
                ],
              ),
              Gap(32.h),
              Text(Label.rateYourExperience, style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", weight: FontWeight.w900, color: AppColors.primaryColor, fontSize: 24, lineHeight: 1.33), textAlign: TextAlign.center)
                  .animate(delay: 100.ms)
                  .slide(
                begin: const Offset(0, -0.3),
                end: const Offset(0, 0), // End at center
                duration: 600.ms,
                curve: Curves.easeOutBack,
              )
                  .fade(begin: 0, end: 1, duration: 600.ms),
              Gap(40.h),
              CircleAvatar(
                radius: 34,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ),
              ),
              Gap(24.h),
              Container(
                padding: const EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How was your ride?',
                      style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 12, color: AppColors.greyAd, weight: FontWeight.w700),
                    ),
                    Gap(16.h),
                    StarRating(
                      rating: rating,
                      color: AppColors.yellow,
                      size: 44,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_outline,
                      halfFilledIcon: Icons.star_half,
                      allowHalfRating: true,
                      onRatingChanged: (value) {
                        setState(() {
                          rating = value;
                        });
                      },
                    ),
                    Gap(16.h),
                    CustomTextField(
                      hintText: "Type your feedback (Quick Select)",
                      controller: reviewController,
                      minLines: 4,
                      expandable: true,
                      onChanged: (value){

                      },
                    ),
                    Gap(16.h),
                    Wrap(
                      spacing: 4.w,
                      runSpacing: 4.h,
                      children: List.generate(Label.suggestedRatingWords.length,
                              (index) {
                            var suggestion = Label.suggestedRatingWords[index];
                            return ChoiceChip(
                              label: Text(
                                suggestion,
                                style: AppThemes.getCustomTextStyle(fontFamily: "Outfit", fontSize: 12, color: selectedSuggestion.contains(suggestion) ? AppColors.white : AppColors.purple, weight: FontWeight.w500),
                              ),
                              selected: selectedSuggestion.contains(suggestion),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
                              backgroundColor: AppColors.purple.withValues(alpha: 0.2),
                              selectedColor: AppColors.purple,
                              onSelected: (selected) {
                                setState(() {
                                  if(selected == false) {
                                    selectedSuggestion.remove(suggestion);
                                  }else {
                                    selectedSuggestion.clear();
                                    selectedSuggestion.add(suggestion);
                                    selectedSuggestionText = suggestion;
                                  }
                                });
                              },
                            ).animate()
                                .slide(
                              begin: const Offset(0.3, 0),
                              end: const Offset(0, 0), // End at center
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            )
                                .fade(begin: 0, end: 1, duration: 600.ms);
                          }),
                    ),
                  ],
                ),
              ),
              Gap(30.h),
              Align(
                alignment: Alignment.center,
                child: DefaultButton(
                  onBtnTap: () async {
                    bool success = await rideProvider.rateTrip({
                      "ride": rideProvider.selectedRide?.uuid,
                      "score": rating,
                      "comment": reviewController.text.trim(),
                      "impression_option": selectedSuggestionText
                    });
                    if(success) {
                      Navigator.pop(context);
                      rideProvider.resetRideState();
                      Get.offAll(()=> AppNavigationScreen());
                    }

                  },
                  btnText: Label.submitReview,
                  isIconPresent: false,
                  width: 0.7.sw,
                  btnColor: AppColors.purple,
                  btnTextColor: AppColors.white,
                ),
              ),
              Gap(10.h),
              Align(
                alignment: Alignment.center,
                child: DefaultButton(
                  onBtnTap: (){
                    Navigator.pop(context);
                    rideProvider.resetRideState();
                    Get.offAll(()=> AppNavigationScreen());
                    setState(() {
                      selectedSuggestion.clear();
                    });
                  },
                  btnText: Label.skipReview,
                  isIconPresent: false,
                  width: 0.7.sw,
                  btnColor: AppColors.lightPurple,
                  btnTextColor: AppColors.purple,
                ),
              ),
            ],
          ),
          Visibility(
            visible: rideProvider.isLoading,
            child: const Loader(),
          )
        ],
      ),
    );
  }
}
