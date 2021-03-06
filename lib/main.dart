import 'package:am_debug/Services/analytics_service.dart';
import 'package:am_debug/UI/AppStartAnimation.dart';
import 'package:am_debug/UI/Dashboard/DashboardScreen.dart';
import 'package:am_debug/UI/Dashboard/Profilepage.dart';
import 'package:am_debug/UI/Registration/AddProfilePicture.dart';
import 'package:am_debug/UI/Registration/UserInformation.dart';
import 'package:am_debug/UI/Sign%20In/LoginScreen.dart';
import 'package:am_debug/UI/Sign%20In/otp.dart';
import 'package:am_debug/UI/Trips/AirportSearch.dart';
import 'package:am_debug/UI/one-to-one%20chatting/Chat.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/UI/Flights/FlightsList.dart';
import 'package:am_debug/helpers/members_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  // Firebase Initialize
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  //SharedPreferences.setMockInitialValues({});

  // Stream Initialize
  Constants.client = new StreamChatClient(
    'zaqch24sqnwh',
    logLevel: Level.INFO,
  );
  runApp(MyApp());
}

// Google Analytics Initialize
FirebaseAnalytics analytics = FirebaseAnalytics();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      builder: (context, child) => StreamChat(
        client: Constants.client,
        child: child,
      ),
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Baloo Tamma 2'),
      home: AppStartAnimation(),
    );
  }
}
