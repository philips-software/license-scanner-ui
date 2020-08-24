import 'dart:async';

import 'package:license_scanner_ui/services/scanner_client.dart';

import 'scan_result.dart';

/// Service API for accessing scanning results.
class ScanService {
  final _scannedController = StreamController<List<ScanResult>>.broadcast();

  /// Provides the latest scan results.
  Stream<List<ScanResult>> get lastScanned {
    refreshScans();
    return _scannedController.stream;
  }

  /// Updates the latest scanned list
  void refreshScans() {
    ScannerClient().refreshScanned(_scannedController.sink);
  }

  void dispose() => _scannedController.close();
}
