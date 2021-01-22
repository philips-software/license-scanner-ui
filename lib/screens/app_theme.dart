/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'app_router.dart';

class AppTheme extends StatelessWidget {
  AppTheme({this.platform, this.child});

  final TargetPlatform platform;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'License Scanner',
      // themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
        indicatorColor: Colors.blueAccent,
        toggleableActiveColor: Colors.blueAccent,
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[700],
        accentColor: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.blue[50],
        // buttonColor: Colors.blue[900],
      ),
      builder: (context, widget) => ResponsiveWrapper.builder(
        widget,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(color: Colors.blue[50]),
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}
