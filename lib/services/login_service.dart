

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
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
}