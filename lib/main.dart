import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:sfs/pages/login.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() => runApp(MaterialApp(
  title: 'SFS Moe',
  home: LoginWidget(),
  navigatorObservers: [
    FirebaseAnalyticsObserver(analytics: analytics),
  ],
));
