



import 'dart:ui';
import 'dart:ui' as ui;

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ridex/app/app_config.dart';
import 'package:ridex/data/constants/api_constants.dart';
import 'package:ridex/data/models/user_model.dart';
import 'package:ridex/services/http_service.dart';
import 'package:ridex/ui/screens/auth/image_capture_screen.dart';
import 'package:ridex/ui/screens/auth/login_screen.dart';
import 'package:ridex/ui/screens/auth/password_screen.dart';
import 'package:ridex/ui/screens/auth/register_screen.dart';

import '../core/cache_helper.dart';

class LoginService extends HttpService {

  //login
  login(Map<String, dynamic> data) async {
    var body = dio.FormData.fromMap(data);
    var response = await loginPost(Api.login, body: body);
    return response;
  }
  //register
  register(Map<String, dynamic> data) async {
    var body = dio.FormData.fromMap(data);
    var response = await loginPost(Api.register, body: body);
    return response;
  }

  //get the drivers
  getDrivers() async {
    var response = await get(Api.drivers);
    return response;
  }

  //logout
  logout() async {
    var response = await loginPost(Api.logout);
    return response;
  }

  //is user logged in
  Future<bool> isUserSignedIn() async {
    var data = await CacheHelper.instance.readModel(CacheHelper.authKey);
    AuthModel? model = AuthModel.fromJson(data);
    if(model.token != null) return true;
    return false;
  }

  //check the page for the
  Future<Object? Function()> checkRegistrationPage() async {
    Map? data = await CacheHelper.instance.readModel(CacheHelper.registerProcessKey);

    if(data != null) {
      if(data.containsKey("full_name")) {
        return () =>  Get.offAll(() => const RegisterScreen());
      }
      if(data.containsKey("avatar")) {
        return () =>  Get.to(() => const ImageCaptureScreen());
      }
      if(data.containsKey("password1")) {
        return () =>  Get.to(() => const PasswordScreen());
      }
    }
    return () =>  Get.to(() => const LoginScreen());

  }

  //get all locations
  loadAllLocations() async {
    var response = await get("${Api.rides}locations/");
    return response;
  }


  Future<BitmapDescriptor> svgToBitmap({
    required BuildContext context,
    required String svgAssetPath,
    Size size = const Size(16, 16),
  }) async {
    final pictureInfo = await vg.loadPicture(SvgAssetLoader(svgAssetPath), null);
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final width = (size.width * devicePixelRatio).toInt();
    final height = (size.height * devicePixelRatio).toInt();

    final scaleFactor = (width / pictureInfo.size.width).clamp(0.1, 10.0);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final image = await recorder.endRecording().toImage(width, height);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }


}