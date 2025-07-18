

import 'package:flutter/cupertino.dart';
import 'package:ridex/services/image_service.dart';

import '../data/locator.dart';
import '../services/dialog_service.dart';
import '../services/login_service.dart';

enum UiState {idle, loading, done, error}
class BaseProvider with ChangeNotifier {


  var auth =  locator<LoginService>();
  var dialog = locator<DialogService>();
  var image = locator<ImageService>();

  UiState uiState = UiState.idle;

  bool get isLoading => uiState == UiState.loading;

  bool get done => uiState == UiState.done;

  bool get error => uiState == UiState.error;


  setUiState(UiState _uiState) {
    uiState = _uiState;
    notifyListeners();
  }


  updateUi(func) {
    func();
    notifyListeners();
  }
}