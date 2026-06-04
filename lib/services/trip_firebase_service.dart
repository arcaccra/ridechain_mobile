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
      // 1. Create request in Firestore
      await _firestore
          .collection('trips')
          .doc(tripId)
          .collection('requests')
          .doc(userId)
          .set({
        'tripId': tripId,
        'userId': userId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Get trip details — guard against missing document
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      if (!tripDoc.exists || tripDoc.data() == null) {
        print('⚠️ Trip document not found: $tripId');
        return;
      }
      final tripData = tripDoc.data()!;

      // 3. Get user details — guard against missing document
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists || userDoc.data() == null) {
        print('⚠️ User document not found: $userId');
        return;
      }
      final userData = userDoc.data()!;

      // 4. Get driver FCM token
      final driverId = tripData['driverId'] as String?;
      if (driverId == null) {
        print('⚠️ Trip has no driverId field');
        return;
      }

      final driverDoc =
          await _firestore.collection('users').doc(driverId).get();
      final driverToken = driverDoc.data()?['fcmToken'] as String?;

      if (driverToken == null) {
        print('⚠️ Driver FCM token not found for driverId: $driverId');
        return;
      }

      // 5. Send notification to driver
      await _notificationService.sendTripRequestNotification(
        tripId: tripId,
        userId: userId,
        driverToken: driverToken,
        userName: (userData['name'] as String?) ?? 'A user',
        destination: (tripData['destination'] as String?) ?? 'your destination',
      );

      print('✅ Trip request notification sent to driver');
    } catch (e, stack) {
      print('❌ Error sending trip request: $e\n$stack');
      rethrow;
    }
  }

  // ========================================
  // 2. PAYMENT COMPLETED
  // ========================================
  Future<void> completePayment({
    required String paymentId,
    required String tripId,
    required String userId,
    required String username,
    required double amount,
  }) async {
    try {
      // 1. Record payment in Firestore
      await _firestore.collection('payments').doc(paymentId).set({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      // 2. Get trip details — guard against missing document
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      if (!tripDoc.exists || tripDoc.data() == null) {
        print('⚠️ Trip document not found: $tripId');
        return;
      }
      final tripData = tripDoc.data()!;
      final driverId = tripData['driverId'] as String?;
      if (driverId == null) {
        print('⚠️ Trip has no driverId field');
        return;
      }

      // 3. Get user and driver FCM tokens
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final driverDoc =
          await _firestore.collection('users').doc(driverId).get();

      final userToken = userDoc.data()?['fcmToken'] as String?;
      final driverToken = driverDoc.data()?['fcmToken'] as String?;

      // 4. Notify passenger
      if (userToken != null) {
        await _notificationService.sendPaymentNotification(
          token: userToken,
          paymentId: paymentId,
          tripId: tripId,
          amount: amount,
          isDriver: false,
        );
      }

      // 5. Notify driver
      if (driverToken != null) {
        await _notificationService.sendPaymentNotification(
          token: driverToken,
          paymentId: paymentId,
          tripId: tripId,
          amount: amount,
          isDriver: true,
          userName: username,
        );
      }

      print('✅ Payment completed successfully');
    } catch (e, stack) {
      print('❌ Error completing payment: $e\n$stack');
      rethrow;
    }
  }

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Returns trip data map or null if document missing / on error.
  Future<Map<String, dynamic>?> getTripDetails(String tripId) async {
    try {
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      if (!tripDoc.exists) return null;
      return tripDoc.data();
    } catch (e) {
      print('❌ Error getting trip details: $e');
      return null;
    }
  }

  /// Real-time stream of trips this passenger is part of.
  Stream<QuerySnapshot> getUserTrips(String userId) {
    return _firestore
        .collection('trips')
        .where('passengerIds', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Creates or overwrites the Firestore user document for [user].
  Future<void> createNewUser({required UserModel user}) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id.toString())
          .set({
        'userId': user.id.toString(),
        'name': user.fullName,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e, stack) {
      print('❌ Error creating user in Firestore: $e\n$stack');
      rethrow;
    }
  }
}
