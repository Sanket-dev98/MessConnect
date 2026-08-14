import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Manages Firebase Cloud Messaging and local notifications.
///
/// Handles:
/// - Token generation and registration
/// - Foreground message handling
/// - Background message handling
/// - Local notification display
class FcmService {
  FcmService._internal();

  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;

  /// Platform-specific FCM initialization
  Future<void> init() async {
    // Request permissions for notifications (only on mobile platforms)
    await _requestNotificationPermissions();

    // Get the FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    log('FCM token: $token');

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    // Handle messages when app is in background / tapped notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(_onMessageOpenedApp);

    // Listen for when a notification is opened
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _requestNotificationPermissions() async {
    // On Android and iOS, request notification permission
    await FirebaseMessaging.instance.requestPermission();
  }

  /// Background message handler - runs when app is terminated/in background
  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    // Must be top-level static method for Firebase background handling
    _showLocalNotification(message);
  }

  /// Handle foreground messages
  void _onMessageHandler(RemoteMessage message) {
    _showLocalNotification(message);
  }

  /// Handle notification tap opening
  void _onMessageOpenedApp(RemoteMessage? message) {
    if (message != null) {
      log('Notification opened from app state: ${message.data}');
      // Navigate based on data - in full implementation
    }
  }

  /// Show a local notification
  static void _showLocalNotification(RemoteMessage message) {
    final String? title = message.notification?.title;
    final String? body = message.notification?.body;

    if (title != null && body != null) {
      debugPrint('Showing notification: $title - $body');
      // In full implementation, use flutter_local_notifications plugin
    }
  }

  /// Handle incoming message when app was quit/terminated
  void handleInitialMessage(RemoteMessage? message) {
    if (message != null) {
      debugPrint('Initial message: ${message.data}');
    }
  }
}