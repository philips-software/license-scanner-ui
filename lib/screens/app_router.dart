/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:license_scanner_ui/model/scan_result.dart';
import 'package:license_scanner_ui/screens/results/results_screen.dart';
import 'package:license_scanner_ui/screens/scan/scan_screen.dart';
import 'package:license_scanner_ui/screens/search/search_screen.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return (Platform.isIOS)
        ? CupertinoPageRoute(builder: (_) => _screenFor(settings))
        : MaterialPageRoute(builder: (_) => _screenFor(settings));
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
    }
  }
}
