import "package:firebase_messaging/firebase_messaging.dart";

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title : ${message.notification?.title}'); // ✅ Added semicolon
  print('Body : ${message.notification?.body}'); // ✅ Added semicolon
  print('Payload : ${message.data}'); // ✅ Corrected access to `data`
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(); // ✅ Added semicolon
    final fCMToken = await _firebaseMessaging.getToken(); // ✅ Correct variable usage
    print('Token: $fCMToken'); // ✅ Added semicolon
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
