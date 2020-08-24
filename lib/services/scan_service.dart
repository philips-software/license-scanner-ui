import 'dart:async';

import 'package:license_scanner_ui/services/scanner_client.dart';

import 'scan_result.dart';

/// Service API for accessing scanning results.
class ScanService {
  final _scannedController = StreamController<List<ScanResult>>.broadcast();
  final _searchController = StreamController<List<ScanResult>>.broadcast();
  final _scannerClient = ScannerClient();

  /// Provides the latest scan results.
  Stream<List<ScanResult>> get lastScanned {
    refreshScans();
    return _scannedController.stream;
  }

  /// Updates the latest scanned list
  Future<void> refreshScans() {
    return _scannerClient.refreshScanned(_scannedController.sink);
  }

  /// Provides search results.
  Stream<List<ScanResult>> get lastSearched {
    return _searchController.stream;
  }

  void search(String name) {
      _scannerClient.search(_searchController.sink, name) ;
  }

  void dispose() {
    _scannedController.close();
    _searchController.close();
  }
}
