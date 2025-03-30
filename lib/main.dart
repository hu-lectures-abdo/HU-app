// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // Controller
//   final WebViewController controller = WebViewController()
//     ..loadRequest(Uri.parse('https://www.google.com'));
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Google Website'),
//           ),
//           body: WebViewWidget(controller: controller)),
//     );
//   }
// }
import 'dart:io'; // Detect platform
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF)) // White background
      ..enableZoom(false) // Disable zoom for a better experience
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true); // Show loader when page reloads
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false); // Hide loader after load
          },
        ),
      )
      ..loadRequest(Uri.parse('https://hu-stu-lectures.vercel.app'));
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: Platform.isIOS
            ? const CupertinoNavigationBar(
                middle: Text('HU LECTURES', style: TextStyle(fontSize: 18)),
              )
            : AppBar(
                title: const Text('HU LECTURES'),
                centerTitle: true,
                elevation: 4,
                backgroundColor: Colors.blueAccent,
              ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller), // WebView content
            if (_isLoading) // Show loading screen
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/android-chrome-512x512-99.png', width: 120), // Logo
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(), // Loading indicator
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
