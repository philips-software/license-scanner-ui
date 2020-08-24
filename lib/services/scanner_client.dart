import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'scan_result.dart';

/// License Scanner service client.
/// See https://github.com/philips-labs/license-scanner
class ScannerClient {
  Uri baseUrl = Uri.http(kIsWeb ? '' : 'localhost:8080', '/package/');

  final _client = Client();

  /// Queries latest scanned packages, reporting results and errors in the [sink].
  Future<void> refreshScanned(EventSink<List<ScanResult>> sink) async {
    return _catchErrorsToSink(sink, () async {
      final entity = await _client.read(baseUrl.resolve('scans'));
      sink.add(_toScanResults(json.decode(entity)));
    });
  }

  /// Queries for named package, reporting results and errors in the [sink].
  void search(StreamSink<List<ScanResult>> sink, String name) async {
    _catchErrorsToSink(sink, () async {
      final entity = await _client.read(baseUrl.resolve('?name=$name'));
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

  List<ScanResult> _toScanResults(Map<String, dynamic> map) {
    final List<dynamic> results = map['results'];
    return results.map((scan) => ScanResult.fromMap(scan)).toList();
  }
}
