import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/firebase_options.dart';
import 'package:ridex/services/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'core/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  setUpLocator();
  //this will initialize the cache helper
  final prefs = await SharedPreferences.getInstance();
  CacheHelper.instance.init(prefs);

  FCMService.instance.initialize();

  // create the app config
  AppConfig.create(
      appName: "Ride chain",
      baseUrl: "https://app.arcaccra.com/",
      flavor: Flavor.prod
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,           // Transparent = uses SafeArea color
    statusBarBrightness: Brightness.light,        // iOS: light bg → black icons
    statusBarIconBrightness: Brightness.dark,     // Android: black icons
    systemNavigationBarColor: Colors.white,       // Nav bar: white
    systemNavigationBarIconBrightness: Brightness.dark, // Nav bar: black icons
  ));

  runApp(const MyApp());
}


