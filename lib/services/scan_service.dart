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

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_scanner_ui/model/detection.dart';
import 'package:license_scanner_ui/model/file_fragment.dart';
import 'package:provider/provider.dart';

import '../model/scan_result.dart';
import 'scanner_client.dart';

/// Service API for accessing scanning results.
class ScanService extends ChangeNotifier {
  ScanService();

  factory ScanService.of(BuildContext context) =>
      Provider.of<ScanService>(context, listen: false);

  final _searchController = StreamController<List<ScanResult>>.broadcast();
  final _scannerClient = ScannerClient();

  int licenseCount = 0;
  int errorCount = 0;
  int contestCount = 0;

  /// Provides search results.
  Stream<List<ScanResult>> get lastSearched => _searchController.stream;

  /// Searches for packages matching [namespace] and [name], producing
  /// results in the [lastSearched] stream.
  void search(String namespace, String name) =>
      _scannerClient.search(_searchController.sink, namespace, name);

  /// Returns recent scan errors.
  Future<List<ScanResult>> latest() =>
      _scannerClient.latestScanResults(_processStats);

  /// Returns all scan errors.
  Future<List<ScanResult>> errors() => _scannerClient.scanErrors(_processStats);

  /// Returns all contested scans.
  Future<List<ScanResult>> contested() =>
      _scannerClient.contested(_processStats);

  /// Returns the scan result indicated by [uuid].
  Future<ScanResult> getScanResult(String uuid) =>
      _scannerClient.getScanResult(uuid);

  /// Trigger new scan of an existing [purl] from [location].
  Future<void> rescan(Uri purl, String location) =>
      _scannerClient.rescan(purl, location);

  /// Override the [license] for the [scan].
  /// If no license is provided, the existing license value is confirmed.
  Future<void> confirm(ScanResult scan, String license) async {
    await _scannerClient.confirm(scan.id, license);
    scan.license = license;
  }

  /// Marks the detection for [detection] of [scan] as false-positive.
  Future<void> ignore(ScanResult scan, Detection detection,
      {ignore = true}) async {
    await _scannerClient.ignore(scan.id, detection.license, ignore: ignore);
    detection.ignored = ignore;
  }

  /// Removes the package with its scan data.
  Future<void> delete(ScanResult scan) => _scannerClient.delete(scan.id);

  /// Gets a sample of the the detection source for a [license] of a [scan]
  /// with a [margin] number of lines.
  Future<FileFragment> detectionSource(
          ScanResult scan, String license, int margin) =>
      _scannerClient.sourceFor(scan.id, license, margin: margin);

  void _processStats({int licenses, int errors, int contested}) {
    licenseCount = licenses;
    errorCount = errors;
    contestCount = contested;
    notifyListeners();
  }

  void dispose() {
    _searchController.close();
    super.dispose();
  }
}
