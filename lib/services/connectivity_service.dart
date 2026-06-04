import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../ui/shared_widgets/no_internet_modal.dart';
import 'dialog_service.dart';

class ConnectionService {
  static final ConnectionService instance = ConnectionService._internal();

  factory ConnectionService() => instance;

  ConnectionService._internal();

  final DialogService _dialogService = DialogService();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _modalVisible = false;

  // ========================================
  // INITIALIZE — call once from MyApp.initState
  // ========================================
  Future<void> initialize() async {
    // Avoid stacking subscriptions if called more than once
    await _subscription?.cancel();

    _subscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  // ========================================
  // CLOSE — cancel subscription on app teardown
  // ========================================
  Future<void> closeConnection() async {
    await _subscription?.cancel();
    _subscription = null;
    _modalVisible = false;
  }

  // ========================================
  // PRIVATE: Handle connectivity changes
  // ========================================
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final isConnected = results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);

    if (isConnected) {
      // Dismiss the no-internet modal only if it's currently shown
      if (_modalVisible) {
        _modalVisible = false;
        // Use GetX navigator — safe because it holds a reference to the overlay
        if (Get.isOverlaysOpen) Get.back();
      }
    } else {
      // Only show the modal once; avoid stacking duplicates
      if (!_modalVisible) {
        _modalVisible = true;
        final context = Get.overlayContext ?? Get.context;
        if (context != null) {
          _dialogService.showCustomModal(
            context: context,
            isDismissible: false,
            customModal: NoInternetModal(),
          );
        } else {
          // Navigator not ready yet — retry after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            final retryContext = Get.overlayContext ?? Get.context;
            if (retryContext != null) {
              _dialogService.showCustomModal(
                context: retryContext,
                isDismissible: false,
                customModal: NoInternetModal(),
              );
            }
          });
        }
      }
    }
  }
}
