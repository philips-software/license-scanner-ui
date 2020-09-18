import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:provider/provider.dart';

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
        title: 'License Scanner',
        theme: ThemeData.light(),
        routes: routes,
        initialRoute: '/',
      ),
    );
  }
}

