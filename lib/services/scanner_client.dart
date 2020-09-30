/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'scan_result.dart';

/// License Scanner service client.
/// See https://github.com/philips-labs/license-scanner
class ScannerClient {
  final _jsonRequestHeader = {'Content-Type': 'application/json'};
  final baseUrl = Uri.http(kIsWeb ? '' : 'localhost:8080', '/');
  final _client = Client();

  /// Queries latest scanned packages, reporting results and errors in the [sink].
  Future<void> refreshScanned(EventSink<List<ScanResult>> sink) async {
    return _catchErrorsToSink(sink, () async {
      final entity = await _client.read(baseUrl.resolve('scans'));
      sink.add(_toScanResults(json.decode(entity)));
    });
  }

  /// Queries for named package, reporting results and errors in the [sink].
  void search(
      StreamSink<List<ScanResult>> sink, String namespace, String name) async {
    _catchErrorsToSink(sink, () async {
      namespace = Uri.encodeComponent(namespace);
      name = Uri.encodeComponent(name);
      final path = 'packages?namespace=$namespace&name=$name';
      final entity = await _client.read(baseUrl.resolve(path));
      sink.add(_toScanResults(json.decode(entity)));
    });
  }

  Future<void> _catchErrorsToSink<T extends EventSink>(
      T sink, Future Function() action) async {
    try {
      await action();
    } on Exception catch (ex) {
      log('REST request failed', error: ex);
      sink.addError(ex);
    }
  }

  Future<ScanResult> scanResultByUuid(String uuid) async {
    final path = 'scans/$uuid';
    final entity = await _client.read(baseUrl.resolve(path));
    return ScanResult.fromMap(json.decode(entity));
  }

  Future<ScanResult> scanResultByPackage(ScanResult pkg) async {
    final path = 'packages/${_pathForPackage(pkg)}';
    final entity = await _client.read(baseUrl.resolve(path));
    return ScanResult.fromMap(json.decode(entity));
  }

  String _pathForPackage(ScanResult pkg) {
    final namespace = Uri.encodeComponent(pkg.namespace);
    final name = Uri.encodeComponent(pkg.name);
    final version =
        Uri.encodeComponent(pkg.version.isNotEmpty ? pkg.version : " ");
    return '$namespace/$name/$version';
  }

  List<ScanResult> _toScanResults(Map<String, dynamic> map) {
    final List<dynamic> results = map['results'];
    return results.map((scan) => ScanResult.fromMap(scan)).toList();
  }

  Future<void> rescan(ScanResult package, String location) async {
    final path = 'packages/${_pathForPackage(package)}?force=yes';
    final body = jsonEncode({'location': location});
    return _success(_client.post(
      baseUrl.resolve(path),
      body: body,
      headers: _jsonRequestHeader,
    ));
  }

  Future<void> confirm(String uuid, String license) async {
    final path = 'scans/$uuid';
    final body = jsonEncode({'license': license});
    return _success(_client.put(
      baseUrl.resolve(path),
      body: body,
      headers: _jsonRequestHeader,
    ));
  }

  Future<void> _success(Future<Response> request) async {
    final response = await request;
    if (response.statusCode != 200) {
      throw new ClientException(
          'Status ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
