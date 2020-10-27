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
  final _searchController = StreamController<List<Uri>>.broadcast();
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
  Stream<List<Uri>> get lastSearched => _searchController.stream;

  /// Searches for packages matching [namespace] and [name], producing
  /// results in the [lastSearched] stream.
  void search(String namespace, String name) =>
      _scannerClient.search(_searchController.sink, namespace, name);

  /// Returns recent scan errors.
  Future<List<ScanResult>> latest() => _scannerClient.latestScanResults();

  /// Returns all scan errors.
  Future<List<ScanResult>> errors() => _scannerClient.scanErrors();

  /// Returns all contested scans.
  Future<List<ScanResult>> contested() => _scannerClient.contested();

  /// Returns the scan result indicated by [uuid].
  Future<ScanResult> getScanResult(String uuid) =>
      _scannerClient.scanResultByUuid(uuid);

  /// Returns the most recent scan result for [purl].
  Future<ScanResult> getPackageScanResult(Uri purl) =>
      _scannerClient.scanResultByPackage(purl);

  /// Trigger new scan of an existing [purl] from [location].
  Future<void> rescan(Uri purl, String location) =>
      _scannerClient.rescan(purl, location);

  /// Override the [license] for the scan indicated by the [uuid].
  /// If no license is provided, the existing license value is confirmed.
  Future<void> confirm(String uuid, String license) =>
      _scannerClient.confirm(uuid, license);

  void dispose() {
    _scannedController.close();
    _searchController.close();
  }
}
