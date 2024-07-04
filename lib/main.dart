import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medigaze/Authentication/login.dart';
import 'package:medigaze/HomePage/home.dart';
import 'package:medigaze/firebase_options.dart';
import 'package:medigaze/theme/theme_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await checkAndRequestNotificationPermissions();

  // Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');

  runApp(MyApp());
}

Future<void> checkAndRequestNotificationPermissions() async {
  var status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'customer_app',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(), // Check login status asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator while checking login status
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            // Handle errors if any
            return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            // Return the appropriate screen based on the login status
            return snapshot.data == true ? HomePage() : LogInOneScreen();
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('user_token');
    String? expirationDateString = prefs.getString('expiration_date');

    if (token != null && expirationDateString != null) {
      DateTime expirationDate =
          DateTime.tryParse(expirationDateString) ?? DateTime.now();

      if (expirationDate.isAfter(DateTime.now())) {
        // Token is still valid, return true
        return true;
      }
    }

    // Token is not valid or not present, return false
    return false;
  }
}
