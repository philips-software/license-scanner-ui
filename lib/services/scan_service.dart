/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'dart:async';

import 'scan_result.dart';
import 'scanner_client.dart';

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
  Future<void> refreshScans() =>
      _scannerClient.refreshScanned(_scannedController.sink);

  /// Provides search results.
  Stream<List<ScanResult>> get lastSearched => _searchController.stream;

  /// Searches for packages matching [namespace] and [name], producing
  /// results in the [lastSearched] stream.
  void search(String namespace, String name) =>
      _scannerClient.search(_searchController.sink, namespace, name);

  /// Returns the scan result indicated by [uuid].
  Future<ScanResult> getScanResult(String uuid) =>
      _scannerClient.scanResultByUuid(uuid);

  /// Returns the most recent scan result for [package].
  Future<ScanResult> getPackageScanResult(ScanResult package) =>
      _scannerClient.scanResultByPackage(package);

  /// Trigger new scan of an existing [package] from [location].
  Future<void> rescan(ScanResult package, String location) =>
      _scannerClient.rescan(package, location);

  /// Override the [license] for the scan indicated by the [uuid].
  /// If no license is provided, the existing license value is confirmed.
  Future<void> confirm(String uuid, String license) =>
      _scannerClient.confirm(uuid, license);

  void dispose() {
    _scannedController.close();
    _searchController.close();
  }
}
