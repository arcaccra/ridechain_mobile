

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:image/image.dart' as img;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridex/core/cache_helper.dart';
import 'package:ridex/data/models/driver_model.dart';
import 'package:ridex/data/models/location_model.dart';
import 'package:ridex/data/models/wallet.dart';
import 'package:ridex/providers/base_provider.dart';
import 'package:ridex/ui/screens/auth/otp_screen.dart';
import 'package:ridex/ui/screens/auth/password_screen.dart';
import 'package:ridex/ui/screens/navigation/app_navigation_screen.dart';

import '../data/models/api_response.dart';
import '../data/models/user_model.dart';

class AuthVm extends BaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthModel? _currentUser;
  Wallet? userWallet;
  UserModel? _model;
  List<DriverModel> allDrivers = [];
  String _verificationId = '';
  bool _authIsLoading = false;
  String? _errorMessage;
  String? walletAddress;
  List<LocationModel> allLocations = [];

  File? imageFile;

  dio.MultipartFile? selectedFile;

  Map<String, dynamic> body = {};

  AuthModel? get currentAuth => _currentUser;
  UserModel? get currentUser => _model;
  bool get isLoading => _authIsLoading;
  String? get errorMessage => _errorMessage;

  //login into the application
  login() async {
    updateUi(()=> _authIsLoading = true);
    _clearError();
    try{
      var response = await auth.login(body);
      log("auth response $response");
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        _currentUser = AuthModel.fromJson(apiResponse.mappedObjects!);
        _model = _currentUser?.user;
        if(_currentUser != null) {
          await CacheHelper.instance.cacheModel(CacheHelper.authKey, _currentUser);
          await CacheHelper.instance.cacheModel(CacheHelper.userKey, _model);
          await getWalletAddress();
          _clearError();
          clearBodyAndImages();
          Get.offAll(() => const AppNavigationScreen(), transition: Transition.leftToRight);
        }
      } else {
        final rawBody = response?.data;
        final bodyError = (rawBody is Map) ? rawBody['error']?.toString() : null;
        final msg = bodyError
            ?? apiResponse.message
            ?? apiResponse.errors
            ?? 'Login failed. Please try again.';
        dialog.showSnackBar('Login failed', msg, isError: true);
      }
    } catch (e, stackTrace) {
      dialog.showSnackBar("Login failed", e.toString(), isError: true);
      log("${e.toString()} and stacktrace ==> $stackTrace");
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
  }

  Future<bool> updateWalletAddress(Map<String, dynamic> body) async {
    updateUi(()=> _authIsLoading = true);
    try{
      var response = await auth.updateWalletAddress(body);
      log("WALLET ADDRESS=====>> ${response.toString()}");
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        userWallet = Wallet.fromJson(apiResponse.mappedObjects!);
        String address = apiResponse.mappedObjects?['address'];
        if(_model != null) {
          await CacheHelper.instance.cacheString(CacheHelper.walletKey, address);
          await CacheHelper.instance.cacheModel(CacheHelper.walletInfoKey, userWallet);
          walletAddress = address;
        }
        return true;
      } else {
        final msg = apiResponse.message ?? apiResponse.errors ?? 'Request failed. Please try again.';
        dialog.showSnackBar('Error', msg, isError: true);
      }
    } catch (e) {
      dialog.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
    return false;
  }

  //get the wallet by id
  Future<Wallet?> getWalletById(int id) async {
    updateUi(()=> _authIsLoading = true);
    try{
      var response = await auth.getWalletById(id);
      log("WALLET ADDRESS=====>> ${response.toString()}");
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        userWallet = Wallet.fromJson(apiResponse.mappedObjects!);
        String address = apiResponse.mappedObjects?['address'];
        if(_model != null) {
          await CacheHelper.instance.cacheString(CacheHelper.walletKey, address);
          walletAddress = address;
        }
        return userWallet;
      }
    } catch (e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString(), isError: true);
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
    return userWallet;
  }

  //fetch user by id
  Future<UserModel?> getUserById(int id) async {
    _authIsLoading = true;
    try{
      var response = await auth.getUserById(id);
      log("USER=====>> ${response.toString()}");
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        _model = UserModel.fromJson(apiResponse.mappedObjects!);
        return _model;
      }
    } catch (e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString(), isError: true);
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
    return _model;
  }

  Future<bool> getWalletAddress() async {
    updateUi(()=> _authIsLoading = true);
    try{
      var response = await auth.getWalletAddress();
      log("WALLET ADDRESS=====>> ${response.toString()}");
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        userWallet = Wallet.fromJson(apiResponse.mappedObjects!);
        String address = apiResponse.mappedObjects?['address'];
        if(_model != null) {
          await CacheHelper.instance.cacheString(CacheHelper.walletKey, address);
          await CacheHelper.instance.cacheModel(CacheHelper.walletInfoKey, userWallet);
          walletAddress = address;
        }
        return true;
      } else {
        final msg = apiResponse.message ?? apiResponse.errors ?? 'Request failed. Please try again.';
        dialog.showSnackBar('Error', msg, isError: true);
      }
    } catch (e) {
      dialog.showSnackBar("Error", e.toString(), isError: true);
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
    return false;
  }

  fetchUserInfo() async {
    var response = await CacheHelper.instance.readModel(CacheHelper.authKey);
    var userResponse = await CacheHelper.instance.readModel(CacheHelper.userKey);
    if(response != null) {
      _currentUser = AuthModel.fromJson(response);
    }
    //this is user response
    if(userResponse != null) {
      _model = UserModel.fromJson(userResponse);
    }
    String? address = CacheHelper.instance.readString(CacheHelper.walletKey);
    if(address != null) {
      walletAddress = address;
    }

    var wallet = await CacheHelper.instance.readModel(CacheHelper.walletInfoKey);
    if(wallet != null) {
      userWallet = Wallet.fromJson(wallet);
    }

    notifyListeners();
  }

  //register into the application
  register() async {
    updateUi(()=> _authIsLoading = true);
    _clearError();
    try{
      var response = await auth.register(body);
      log(response.toString());
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        _currentUser = AuthModel.fromJson(apiResponse.mappedObjects!);
        _model = _currentUser?.user;
        if(_currentUser != null) {
          await CacheHelper.instance.cacheModel(CacheHelper.authKey, _currentUser);
          await CacheHelper.instance.cacheModel(CacheHelper.userKey, _model);
          await tripService.createNewUser(user: _currentUser!.user!);
          _clearError();
          clearBodyAndImages();
          Get.offAll(() => const AppNavigationScreen(), transition: Transition.leftToRight);
        }
      } else {
        final msg = apiResponse.message ?? apiResponse.errors ?? 'Registration failed. Please try again.';
        dialog.showSnackBar('Registration failed', msg, isError: true);
      }
    } catch (e, stacktrace) {
      dialog.showSnackBar("Registration failed", e.toString(), isError: true);
      imageFile = null;
      selectedFile = null;
      log("${e.toString()} and stacktrace ==> $stacktrace");
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
  }

  //clear the register map
  addToRegisterMap(String key, dynamic value) {
    body[key] = value;
    //save the cacheModel
    //CacheHelper.instance.cacheModel(CacheHelper.registerProcessKey, body);
    log(body.toString());
    notifyListeners();
  }

  createMap(Map _body){
    if(body.isEmpty) {
      body = Map.from(_body);
    }
    log(body.toString());
    notifyListeners();
  }

  // Send OTP to phone number
  Future<void> sendOTP(String phoneNumber) async {
    try {
      updateUi(()=> _authIsLoading = true);
      _clearError();

      // Format phone number (ensure it has country code)
      String formattedPhone = _formatPhoneNumber(phoneNumber);

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),

        // Verification completed (Android only - auto-verification)
        verificationCompleted: (PhoneAuthCredential credential) async {
          Get.to(() => const OtpScreen(), transition: Transition.leftToRight);
        },

        // Verification failed
        verificationFailed: (FirebaseAuthException e) {
          _setError(_getErrorMessage(e));
          dialog.showSnackBar("An unexpected error occurred", e.toString(), isError: true);
          updateUi(()=> _authIsLoading = false);
        },

        // Code sent successfully
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          updateUi(()=> _authIsLoading = false);
          Get.to(() => const OtpScreen(), transition: Transition.leftToRight);
          debugPrint('OTP sent successfully to $formattedPhone');
        },

        // Code auto-retrieval timeout
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          updateUi(()=> _authIsLoading = false);
        },
      );
    } catch (e) {
      _setError('Failed to send OTP: ${e.toString()}');
      dialog.showSnackBar("Failed to send OTP:", e.toString(), isError: true);
      updateUi(()=> _authIsLoading = false);
    }
  }

  // Verify OTP code
  Future<bool> verifyOTP(String otp) async {
    try {
      updateUi(()=> _authIsLoading = true);
      _clearError();

      // Create credential from verification ID and OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      // Sign in with credential
      Get.to(() => const PasswordScreen(), transition: Transition.leftToRight);
      updateUi(()=> _authIsLoading = false);
      return true;

    } catch (e) {
      dialog.showSnackBar("Invalid Otp:", e.toString(), isError: true);
      updateUi(()=> _authIsLoading = false);
      return false;
    }
  }

  // Resend OTP
  Future<void> resendOTP(String phoneNumber) async {
    await sendOTP(phoneNumber);
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Format phone number with country code
  String _formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Add country code if not present (assuming +1 for US)
    if (!cleaned.startsWith('1') && cleaned.length == 10) {
      cleaned = '1$cleaned';
    }

    return '+$cleaned';
  }

  // Get user-friendly error messages
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The phone number is not valid.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Phone authentication is not enabled.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'credential-already-in-use':
        return 'This phone number is already associated with another account.';
      case 'session-expired':
        return 'The verification session has expired. Please try again.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  //image capture
  //capture function captures the image of the user and saves the multipart file
  captureProfilePicture(context, {ImageSource? source}) async {
    updateUi(()=> _authIsLoading = true);
    var pickedImage = await image.captureImage(source);
    if (pickedImage != null) {
      imageFile = File(pickedImage!.path);
      var decodedImage = img.decodeImage(imageFile!.readAsBytesSync());
      var encodedImage = img.encodeJpg(decodedImage!);
      selectedFile = dio.MultipartFile.fromBytes(encodedImage, filename: "image_$imageFile.jpg");
    } else {
      dialog.showSnackBar("Error", "Error picking image... Please try again.", isError: true);
      updateUi(()=> _authIsLoading = false);
    }
    updateUi(()=> _authIsLoading = false);
  }


  bool isFirstTimeDriverLoad = true;
  //get all the drivers
  ///TODO: This call should fetch the drivers based on a radius around their location
  Future<List<DriverModel>> getAllDrivers() async {
    if(isFirstTimeDriverLoad) _authIsLoading = true;
    try {
      var response = await auth.getDrivers();
      isFirstTimeDriverLoad = false;
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        List driversList = apiResponse.listWithoutDataKey;
        allDrivers = driversList.map((e)=> DriverModel.fromJson(e)).toList();
        return allDrivers;
      } else {
        return [];
      }
    } on Exception catch(e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString(), isError: true);
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
    return [];
  }

  //get all locations
  getLocations() async {
    _authIsLoading = true;
    try{
      var response = await auth.loadAllLocations();
      var apiResponse = ApiResponse.parse(response);
      if(apiResponse.code == 200 || apiResponse.code == 201) {
        List locations = apiResponse.listWithoutDataKey;
        allLocations = locations.map((e)=> LocationModel.fromJson(e)).toList();
        await CacheHelper.instance.cacheModel(CacheHelper.locationsKey, locations);
      } else {
        allLocations = [];
      }

    } on Exception catch(e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString(), isError: true);
    } finally {
      updateUi(()=> _authIsLoading = false);
    }
  }

  Future<bool> logout() async {
     setUiState(UiState.loading);
    try{
      await auth.logout();
      //log(response);
      //var apiResponse = ApiResponse.parse(response);
      //if(apiResponse.code == 200 || apiResponse.code == 201) {
        await CacheHelper.instance.clearCache();
        return true;
      //}
    } on Exception catch(e) {
      dialog.showSnackBar("An unexpected error occurred", e.toString(), isError: true);
    } finally {
      setUiState(UiState.done);
    }
    return false;
  }


  //clear body and images {}

  clearBodyAndImages() {
    body.clear();
    imageFile = null;
    selectedFile = null;
    notifyListeners();
  }

  //clear the error
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}