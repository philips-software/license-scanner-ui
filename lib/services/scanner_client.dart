import 'dart:convert';

import 'package:http/http.dart';

import 'scan_result.dart';

class ScannerClient {
  Uri baseUrl = Uri.http('localhost:8080', '/package/');

  final _client = Client();

  void refreshScanned(Sink<List<ScanResult>> sink) async {
    final entity = await _client.read(baseUrl.resolve('scans'));
    sink.add(_toScanResults(json.decode(entity)));
  }

  List<ScanResult> _toScanResults(Map<String, dynamic> map) {
    final List<dynamic> results = map['results'];
    return results.map((scan) => ScanResult.fromMap(scan)).toList();
  }
}
