/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class AppTheme extends StatelessWidget {
  AppTheme({this.platform, this.routes});

  final TargetPlatform platform;
  final Map<String, Widget Function(BuildContext)> routes;

  @override
  Widget build(BuildContext context) => PlatformProvider(
        initialPlatform: platform,
        builder: (_) => PlatformApp(
          title: 'License Scanner',
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
          material: (_, __) => MaterialAppData(
            themeMode: ThemeMode.light,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.blue[700],
              accentColor: Colors.deepOrange,
              scaffoldBackgroundColor: Colors.blue[50],
              // buttonColor: Colors.blue[900],
            ),
          ),
          cupertino: (_, __) => CupertinoAppData(
            localizationsDelegates: [DefaultMaterialLocalizations.delegate],
            theme: CupertinoThemeData(
              scaffoldBackgroundColor: Colors.blue[50],
              primaryColor: Colors.blue[700],
              primaryContrastingColor: Colors.deepOrange,
              brightness: Brightness.light,
            ),
          ),
          routes: routes,
          initialRoute: '/',
        ),
      );
}
