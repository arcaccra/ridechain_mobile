
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridex/services/fcm_service.dart';

import '../data/models/user_model.dart';

class TripFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FCMService _notificationService = FCMService();

  // ========================================
  // 1. USER REQUESTS TO JOIN TRIP
  // ========================================
  Future<void> requestToJoinTrip(String tripId, String userId) async {
    try {
      print('Sending trip request...');

      // 1. Create request in Firestore
      final requestRef = await _firestore
          .collection('trips')
          .doc(tripId)
          .collection('requests')
          .add({
        'tripId': tripId,
        'userId': userId,
        'status': 'pending',
        'createdAt': DateTime.now(),
      });

      print('Request created in Firestore');

      // 2. Get trip and user details
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      final tripData = tripDoc.data()!;

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data()!;

      // 3. Get driver's FCM token
      final driverDoc = await _firestore
          .collection('users')
          .doc(tripData['driverId'])
          .get();
      final driverToken = driverDoc.data()?['fcmToken'];

      if (driverToken == null) {
        print('⚠️ Driver FCM token not found');
        return;
      }

      // 4. Send notification to driver
      await _notificationService.sendTripRequestNotification(
        tripId: tripId,
        userId: userId,
        driverToken: driverToken,
        userName: userData['name'] ?? 'A user',
        destination: tripData['destination'] ?? 'your destination',
      );

      print('✅ Trip request notification sent to driver');
    } catch (e) {
      print('❌ Error sending trip request: $e');
      throw e;
    }
  }

  // ========================================
  // 4. PAYMENT COMPLETED
  // ========================================
  Future<void> completePayment({
    required String paymentId,
    required String tripId,
    required String userId,
    required double amount,
  }) async {
    try {
      print('📤 Processing payment completion...');

      // 1. Update payment status in Firestore
      await _firestore.collection('payments').doc(paymentId).update({
        'status': 'completed',
        'completedAt': DateTime.now(),
      });
      print('✅ Payment status updated in Firestore');

      // 2. Get trip details
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      final tripData = tripDoc.data()!;
      final driverId = tripData['driverId'];

      // 3. Get user and driver details
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final driverDoc = await _firestore.collection('users').doc(driverId).get();

      final userToken = userDoc.data()?['fcmToken'];
      final driverToken = driverDoc.data()?['fcmToken'];
      final userName = userDoc.data()?['name'];

      // 4. Send notification to user (passenger)
      if (userToken != null) {
        await _notificationService.sendPaymentNotification(
          token: userToken,
          paymentId: paymentId,
          tripId: tripId,
          amount: amount,
          isDriver: false,
        );
        print('✅ Payment notification sent to user');
      }

      // 5. Send notification to driver
      if (driverToken != null) {
        await _notificationService.sendPaymentNotification(
          token: driverToken,
          paymentId: paymentId,
          tripId: tripId,
          amount: amount,
          isDriver: true,
          userName: userName,
        );
        print('✅ Payment notification sent to driver');
      }

      print('✅ Payment completed successfully');
    } catch (e) {
      print('❌ Error completing payment: $e');
      throw e;
    }
  }

  // ========================================
  // HELPER METHODS
  // ========================================

  // Get trip details
  Future<Map<String, dynamic>?> getTripDetails(String tripId) async {
    try {
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      return tripDoc.data();
    } catch (e) {
      print('❌ Error getting trip details: $e');
      return null;
    }
  }

  // Get user's trips (for passenger)
  Stream<QuerySnapshot> getUserTrips(String userId) {
    return _firestore
        .collection('trips')
        .where('passengerIds', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //create a new user whether driver
  Future<void> createNewUser({required UserModel user}) async {
    try {
      await _firestore.collection('users').doc(user.id.toString()).set({
        'userId': user.id.toString(),
        'name': user.fullName,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

}