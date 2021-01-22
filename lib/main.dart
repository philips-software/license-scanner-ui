/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/app_theme.dart';
import 'screens/results/results_screen.dart';
import 'services/scan_service.dart';

const platform = TargetPlatform.fuchsia;
// const platform = TargetPlatform.macOS;

void main() {
  runApp(LicenseScannerApp());
}

class LicenseScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScanService>(
      create: (_) => ScanService(),
      child: AppTheme(
        platform: kDebugMode ? platform : null,
        child: ResultsScreen(),
      ),
    );
  }
}
