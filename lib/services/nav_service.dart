

import 'package:flutter/cupertino.dart';
import 'package:ridex/ui/screens/history/history_screen.dart';
import 'package:ridex/ui/screens/home/home_screen.dart';
import 'package:ridex/ui/screens/profile/profile_screen.dart';
import 'package:ridex/ui/screens/scan/scan_screen.dart';
import 'package:ridex/ui/screens/search/search_screen.dart';

import '../core/core_constants/colors.dart';
import '../core/core_constants/media.dart';
import '../ui/shared_widgets/nav_item.dart';

class NavService {

  //get the navigation items
  static List<NavItem> navigationItems({bool isSelected = false, String? userImage}) {
    return [
      NavItem(
          navData: Media.home,
          navLabel: "Home",
          itemColor: isSelected ? AppColors.primaryColor : AppColors.textFieldHintColor),
      NavItem(
          navData: Media.search,
          navLabel: "Search",
          itemColor: isSelected ? AppColors.primaryColor : AppColors.textFieldHintColor),
      NavItem(
          navData: Media.scan,
          navLabel: "Scan",
          itemColor: isSelected ? AppColors.primaryColor : AppColors.textFieldHintColor),
      NavItem(
          navData: Media.history,
          navLabel: "History",
          isProfile: true,
          itemColor: isSelected ? AppColors.primaryColor : AppColors.textFieldHintColor),
      NavItem(
          navData: Media.profile,
          navLabel: "Profile",
          itemColor: isSelected ? AppColors.primaryColor : AppColors.textFieldHintColor),

    ];
  }

  //get the widgets for the screens
  static Widget? selectedScreen(int currentIndex) {
    List<Widget?> screens = [
      const HomePage(),
      const SearchScreen(),
      const ScanScreen(),
      const HistoryScreen(),
      const ProfileScreen()
    ];
    if (screens[currentIndex] != null) {
      return screens[currentIndex];
    }
    return null;
  }

}