import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/colors.dart';
import '../../../services/nav_service.dart';
import '../../shared_widgets/bottom_nav.dart';



class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> {
  int currentIndex = 0;

  changeTheCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            NavService.selectedScreen(currentIndex)!,
            Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: BottomNav(
                    currentIndex: currentIndex,
                    getCurrentIndex: (index) {
                        changeTheCurrentIndex(index);
                    }).animate().fade().scale(
                  delay: 500.ms,
                ))
          ],
        ),
      ),
    );
  }
}
