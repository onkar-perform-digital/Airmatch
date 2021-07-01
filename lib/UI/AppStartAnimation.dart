import 'package:am_debug/UI/Dashboard/DashboardScreen.dart';
import 'package:am_debug/UI/Sign%20In/LoginScreen.dart';
import 'package:am_debug/helpers/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import "dart:async";

class AppStartAnimation extends StatefulWidget {
  const AppStartAnimation({Key key}) : super(key: key);

  @override
  _AppStartAnimationState createState() => _AppStartAnimationState();
}

class _AppStartAnimationState extends State<AppStartAnimation> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    // For showing this Animation page for this much duration only
    var duration = new Duration(seconds: 2, milliseconds: 300);
    return new Timer(duration, route);
  }

  bool _isLoggedIn = false;

  route() async {
    // Navigator.pushAndRemoveUntil(
    // context,
    // MaterialPageRoute(builder: (context) => LoginScreen()),
    // (route) => false);

    await HelperFunctions.getUserLoggedInPreferenceKey().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }

      if (_isLoggedIn == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(1),
                settings: RouteSettings(name: 'Dashboard Screen')),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen(),
                settings: RouteSettings(name: 'Login Screen')),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: Lottie.asset('Assets/Logo_anim (1).json'));
  }
}
