import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);


  Future setUserProperties({@required String userId, String userRole}) async {
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
    // property to indicate if it's a pro paying member
    // property that might tell us it's a regular poster, etc
  }

  Future logImageAdded({bool hasImage}) async {
    await _analytics.logEvent(
      name: 'added_image',
      parameters: {'has_image': hasImage},
    );
  }

  Future uerCreated(var uid) async {
    await _analytics.setUserId(uid);
  }

  Future userSignedIn(var uid) async {
    await _analytics.logEvent(name: 'user_signedIn', parameters: {'current_user': uid});
  }

  Future userSignedOut(var uid) async {
    await _analytics.logEvent(name: 'user_signedOut', parameters: {'current_user': uid});
  }

  Future currentScreen(String currScrn) async {
    await _analytics.setCurrentScreen(screenName: currScrn);
  }

  Future buttonClicked(String btnName, var uid) async {
    await _analytics.logEvent(name: 'Btn: $btnName clicked', parameters: {'current_user': uid});
  }

  Future grpViews(String grpName, var uid) async {
    await _analytics.logEvent(name: 'Grp $grpName viewed', parameters: {'current_user': uid});
  }
}