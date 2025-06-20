import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ridex/core/theme.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/ui/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  //this will initialize the cache helper
  final prefs = await SharedPreferences.getInstance();
  CacheHelper.instance.init(prefs);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppThemes.appThemeData[AppTheme.darkTheme],
          home: const SplashScreen(),
        );
      }
    );
  }
}
