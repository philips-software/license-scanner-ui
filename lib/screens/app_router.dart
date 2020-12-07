/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:license_scanner_ui/model/scan_result.dart';
import 'package:license_scanner_ui/screens/results/results_screen.dart';
import 'package:license_scanner_ui/screens/scan/scan_screen.dart';
import 'package:license_scanner_ui/screens/search/search_screen.dart';
import 'package:license_scanner_ui/screens/source/source_screen.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => _screenFor(settings));
  }

  static Widget _screenFor(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/results':
        return ResultsScreen();
      case '/scan':
        final Future<ScanResult> future = settings.arguments;
        return ScanScreen(future);
      case '/search':
        return SearchScreen();
      case '/source':
        final args = settings.arguments as Map<String, dynamic>;
        final scan = args['scan'] as ScanResult;
        final filename = args['filename'] as String;
        final license = args['license'] as String;
        return SourceScreen(scan, filename, license);
      default:
        log('Not route for "${settings.name}');
        return null;
    }
  }
}
