/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'routes.dart';

void main() {
  runApp(LicenseScannerApp());
}

class LicenseScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ScanService>(
      create: (_) => ScanService(),
      child: MaterialApp(
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
        title: 'License Scanner',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue[700],
            accentColor: Colors.deepOrange,
            // scaffoldBackgroundColor: Colors.blue[50],
            buttonColor: Colors.blue[900]),
        routes: routes,
        initialRoute: '/',
      ),
    );
  }
}
