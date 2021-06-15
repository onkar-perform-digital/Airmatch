import 'package:am_debug/UI/Sign%20In/LoginScreen.dart';
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
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 2, milliseconds: 300);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: Lottie.asset('Assets/Logo_anim (1).json'));
  }
}
