import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level background message handler — must be top-level for isolate entry.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.title}');
}

class FCMService {
  static final FCMService instance = FCMService._internal();

  factory FCMService() => instance;

  FCMService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging get fcm => _fcm;

  // Notification channels
  static const String CHANNEL_TRIP_REQUEST = 'trip_request_channel';
  static const String CHANNEL_TRIP_UPDATES = 'trip_updates_channel';
  static const String CHANNEL_PAYMENT = 'payment_channel';

  bool _isInitialized = false;

  // ── Stored subscriptions so they can be cancelled ──────────────────────────
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;
  StreamSubscription<String>? _onTokenRefreshSub;

  // ========================================
  // INITIALIZATION
  // ========================================
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load(fileName: ".env");

      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        criticalAlert: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print('⚠️ Notification permission denied');
        return;
      }

      await _createNotificationChannels();
      await _setupMessageHandlers();

      _isInitialized = true;
      print('✅ Notification service initialized');
    } catch (e, stack) {
      print('❌ Error initializing FCMService: $e\n$stack');
      rethrow;
    }
  }

  // ========================================
  // RIDE STATUS LISTENER
  // Returns the StreamSubscription so callers MUST cancel it in dispose().
  // ========================================
  StreamSubscription<RemoteMessage> listenToMessageReceivedForRideStatus(
    void Function(Map<String, dynamic>) onData,
  ) {
    return FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onData(message.data);
    });
  }

  // ========================================
  // TOKEN MANAGEMENT
  // ========================================
  Future<void> saveAnActivateTokenRefresh(String userId) async {
    // Save current token
    final token = await _fcm.getToken();
    if (token != null) {
      await _saveFCMToken(userId, token);
    }

    // Cancel any previous token-refresh listener before registering a new one
    await _onTokenRefreshSub?.cancel();
    _onTokenRefreshSub = _fcm.onTokenRefresh.listen((newToken) {
      _saveFCMToken(userId, newToken);
    });
  }

  // ========================================
  // CANCEL ALL SUBSCRIPTIONS
  // Call this on logout or app teardown.
  // ========================================
  Future<void> cancelSubscriptions() async {
    await _onMessageSub?.cancel();
    await _onMessageOpenedSub?.cancel();
    await _onTokenRefreshSub?.cancel();
    _onMessageSub = null;
    _onMessageOpenedSub = null;
    _onTokenRefreshSub = null;
  }

  // ========================================
  // PRIVATE: Notification channels
  // ========================================
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          CHANNEL_TRIP_REQUEST,
          'Trip Requests',
          description: 'Notifications for incoming trip requests',
          importance: Importance.high,
          enableVibration: true,
          enableLights: true,
          ledColor: Color.fromARGB(255, 255, 152, 0),
        ),
      );

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          CHANNEL_TRIP_UPDATES,
          'Trip Updates',
          description: 'Notifications for trip status changes',
          importance: Importance.high,
          enableVibration: true,
          enableLights: true,
          ledColor: Color.fromARGB(255, 76, 175, 80),
        ),
      );

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          CHANNEL_PAYMENT,
          'Payment Updates',
          description: 'Notifications for payment confirmations',
          importance: Importance.max,
          enableVibration: true,
          enableLights: true,
          ledColor: Color.fromARGB(255, 33, 150, 243),
        ),
      );
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
  }

  // ========================================
  // PRIVATE: Message handlers
  // ========================================
  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Store subscriptions so they can be cancelled later
    _onMessageSub =
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    _onMessageOpenedSub =
        FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundNotificationTap);

    // Handle launch from terminated state
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundNotificationTap(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _showLocalNotification(
      title: notification.title ?? 'Notification',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
      type: message.data['type'] as String? ?? 'general',
    );
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
    required String type,
  }) async {
    String channelId;
    switch (type) {
      case 'trip_request':
        channelId = CHANNEL_TRIP_REQUEST;
        break;
      case 'trip_request_response':
      case 'trip_status_update':
        channelId = CHANNEL_TRIP_UPDATES;
        break;
      case 'payment_completed':
        channelId = CHANNEL_PAYMENT;
        break;
      default:
        channelId = CHANNEL_TRIP_UPDATES;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: _getNotificationColor(type),
      enableVibration: true,
      styleInformation: BigTextStyleInformation(body, contentTitle: title),
    );

    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  void _handleNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;
    try {
      final data =
          Map<String, String>.from(jsonDecode(response.payload!) as Map);
      // TODO: NavigationService.handleNotificationNavigation(data['action'], data);
      print('Notification tapped: action=${data['action']}');
    } catch (e) {
      print('Error parsing notification payload: $e');
    }
  }

  void _handleBackgroundNotificationTap(RemoteMessage message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      // TODO: NavigationService.handleNotificationNavigation(message.data['action'], message.data);
      print('Background notification tapped: action=${message.data['action']}');
    });
  }

  // ========================================
  // PRIVATE: Save FCM token to Firestore
  // ========================================
  Future<void> _saveFCMToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).set(
        {
          'fcmToken': token,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
        SetOptions(merge: true),
      );
      print('✅ FCM token saved for user $userId');
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }

  // ========================================
  // SEND NOTIFICATIONS
  // ========================================

  Future<void> sendTripRequestNotification({
    required String tripId,
    required String userId,
    required String driverToken,
    required String userName,
    required String destination,
  }) async {
    await _sendFCMNotification(
      token: driverToken,
      title: '🚗 New Trip Request',
      body: '$userName wants to join your trip to $destination',
      data: {
        'type': 'trip_request',
        'tripId': tripId,
        'userId': userId,
        'action': 'view_request',
      },
      channelId: CHANNEL_TRIP_REQUEST,
    );
  }

  Future<void> sendTripResponseNotification({
    required String userToken,
    required String tripId,
    required String requestId,
    required bool accepted,
    required String driverName,
  }) async {
    await _sendFCMNotification(
      token: userToken,
      title: accepted ? 'Request Accepted!' : 'Request Declined',
      body: accepted
          ? '$driverName accepted your trip request'
          : '$driverName declined your trip request',
      data: {
        'type': 'trip_request_response',
        'tripId': tripId,
        'requestId': requestId,
        'status': accepted ? 'accepted' : 'declined',
        'action': accepted ? 'view_trip' : 'find_trip',
      },
      channelId: CHANNEL_TRIP_UPDATES,
    );
  }

  Future<void> sendTripStatusNotification({
    required List<String> passengerTokens,
    required String tripId,
    required String status,
    required String driverName,
  }) async {
    String title, body;
    switch (status) {
      case 'arrived_pickup':
        title = 'Driver Arrived';
        body = '$driverName has arrived at your pickup location';
        break;
      case 'started':
        title = 'Trip Started';
        body = '$driverName has started the trip';
        break;
      case 'completed':
        title = 'Trip Completed';
        body = 'Your trip has been completed. Thank you!';
        break;
      default:
        return;
    }

    await Future.wait(
      passengerTokens.map(
        (token) => _sendFCMNotification(
          token: token,
          title: title,
          body: body,
          data: {
            'type': 'trip_status_update',
            'tripId': tripId,
            'status': status,
            'action': 'view_trip',
          },
          channelId: CHANNEL_TRIP_UPDATES,
        ),
      ),
    );
  }

  Future<void> sendPaymentNotification({
    required String token,
    required String paymentId,
    required String tripId,
    required double amount,
    required bool isDriver,
    String? userName,
  }) async {
    await _sendFCMNotification(
      token: token,
      title: isDriver ? '💰 Payment Received' : '💳 Payment Completed',
      body: isDriver
          ? 'You received ₳${amount.toStringAsFixed(2)}${userName != null ? ' from $userName' : ''}'
          : 'Payment of ₳${amount.toStringAsFixed(2)} processed successfully',
      data: {
        'type': 'payment_completed',
        'paymentId': paymentId,
        'tripId': tripId,
        'amount': amount.toString(),
        'role': isDriver ? 'driver' : 'passenger',
        'action': isDriver ? 'view_earnings' : 'view_receipt',
      },
      channelId: CHANNEL_PAYMENT,
    );
  }

  // ========================================
  // PRIVATE: Core FCM v1 HTTP send
  // ========================================
  Future<bool> _sendFCMNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
    String? channelId,
    String? imageUrl,
    String? priority,
  }) async {
    if (token.isEmpty) {
      print('⚠️ FCM token is empty, skipping notification');
      return false;
    }

    try {
      final credentials = await _getAccessToken();
      final accessToken = credentials.accessToken.data;
      final projectId = dotenv.env['PROJECT_ID'];

      if (projectId == null) {
        print('❌ PROJECT_ID not set in .env');
        return false;
      }

      final fcmEndpoint =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      final payload = {
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
            if (imageUrl != null) 'image': imageUrl,
          },
          'data': data,
          'android': {
            'priority': priority ?? 'high',
            'notification': {
              'channel_id': channelId ?? 'default_channel',
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'notification_priority': 'PRIORITY_HIGH',
              'visibility': 'PUBLIC',
            },
          },
          'apns': {
            'headers': {'apns-priority': '10'},
            'payload': {
              'aps': {
                'sound': 'default',
                'badge': 1,
                'content-available': 1,
              },
            },
          },
        },
      };

      final response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('✅ FCM notification sent');
        return true;
      } else {
        print('❌ FCM error ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e, stack) {
      print('❌ Error sending FCM: $e\n$stack');
      return false;
    }
  }

  Future<AccessCredentials> _getAccessToken() async {
    final serviceAccountPath = dotenv.env['PATH_TO_SECRET'];
    if (serviceAccountPath == null) {
      throw Exception('PATH_TO_SECRET not set in .env');
    }
    final serviceAccountJson = await rootBundle.loadString(serviceAccountPath);
    final serviceAccount =
        ServiceAccountCredentials.fromJson(serviceAccountJson);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(serviceAccount, scopes);
    return client.credentials;
  }

  // ========================================
  // HELPER: Channel metadata
  // ========================================
  String _getChannelName(String channelId) {
    switch (channelId) {
      case CHANNEL_TRIP_REQUEST:
        return 'Trip Requests';
      case CHANNEL_TRIP_UPDATES:
        return 'Trip Updates';
      case CHANNEL_PAYMENT:
        return 'Payment Updates';
      default:
        return 'Notifications';
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case CHANNEL_TRIP_REQUEST:
        return 'Incoming trip requests';
      case CHANNEL_TRIP_UPDATES:
        return 'Trip status updates';
      case CHANNEL_PAYMENT:
        return 'Payment confirmations';
      default:
        return 'App notifications';
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'trip_request':
        return const Color.fromARGB(255, 255, 152, 0);
      case 'trip_request_response':
      case 'trip_status_update':
        return const Color.fromARGB(255, 76, 175, 80);
      case 'payment_completed':
        return const Color.fromARGB(255, 33, 150, 243);
      default:
        return const Color.fromARGB(255, 158, 158, 158);
    }
  }

  // ========================================
  // CLEANUP — call on logout
  // ========================================
  Future<void> disposeAndCleanup(String userId) async {
    await cancelSubscriptions();
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'fcmToken': FieldValue.delete()});
      await _fcm.deleteToken();
    } catch (e) {
      print('⚠️ Error during FCM cleanup: $e');
    }
    _isInitialized = false;
  }
}
