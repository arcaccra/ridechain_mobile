import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ridex/data/locator.dart';
import 'package:ridex/firebase_options.dart';
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

  // create the app config
  AppConfig.create(
      appName: "Ride chain",
      baseUrl: "https://app.arcaccra.com/",
      flavor: Flavor.prod
  );
  runApp(const MyApp());
}


