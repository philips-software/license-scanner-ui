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
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../model/scan_result.dart';

/// License Scanner service client.
/// See https://github.com/philips-labs/license-scanner
class ScannerClient {
  final baseUrl = Uri.http(kIsWeb ? '' : 'localhost:8080', '/');
  final _dio = Dio();

  /// Queries latest scanned packages, reporting results and errors in the [sink].
  Future<void> refreshScanned(EventSink<List<ScanResult>> sink) async {
    return _catchErrorsToSink(sink, () async {
      final json = await _get<Map<String, dynamic>>(baseUrl.resolve('scans'));
      sink.add(ScanResult.fromList(json['results']));
    });
  }

  /// Queries for named package, reporting results and errors in the [sink].
  void search(StreamSink<List<Uri>> sink, String namespace, String name) async {
    _catchErrorsToSink(sink, () async {
      final json =
          await _get<Map<String, dynamic>>(baseUrl.resolve('packages').replace(
        queryParameters: {
          'namespace': Uri.encodeComponent(namespace),
          'name': Uri.encodeComponent(name),
        },
      ));
      sink.add(ScanResult.fromPurlList(json['results']));
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

  Future<List<ScanResult>> latestScanResults() async {
    final json = await _get<Map<String, dynamic>>(baseUrl.resolve('scans'));
    return ScanResult.fromList(json['results']);
  }

  Future<List<ScanResult>> scanErrors() async {
    final json =
        await _get<Map<String, dynamic>>(baseUrl.resolve('scans').replace(
      queryParameters: {'q': 'errors'},
    ));
    return ScanResult.fromList(json['results']);
  }

  Future<List<ScanResult>> contested() async {
    final json =
        await _get<Map<String, dynamic>>(baseUrl.resolve('scans').replace(
      queryParameters: {'q': 'contested'},
    ));
    return ScanResult.fromList(json['results']);
  }

  Future<ScanResult> scanResultByUuid(String uuid) async {
    final json =
        await _get<Map<String, dynamic>>(baseUrl.resolve('scans/$uuid'));
    return ScanResult.fromMap(json);
  }

  Future<ScanResult> scanResultByPackage(Uri purl) async {
    final path = 'packages/${_encode(purl)}';
    log('requesting: $path');
    final json = await _get<Map<String, dynamic>>(baseUrl.resolve(path));
    return ScanResult.fromMap(json);
  }

  Future<void> rescan(Uri purl, String location) async {
    final path = 'packages/${_encode(purl)}?force=yes';
    final body = {'location': location};
    await _post(
      baseUrl.resolve(path).replace(
        queryParameters: {'force': 'yes'},
      ),
      body: body,
    );
  }

  Future<void> confirm(String scanId, String license) async {
    final path = 'scans/$scanId';
    final body = {'license': license};
    await _put(baseUrl.resolve(path), body: body);
  }

  Future<void> ignore(String scanId, String license,
      {bool ignore = true}) async {
    final path = 'scans/$scanId/ignore/${license}?revert=${!ignore}';
    await _post(baseUrl.resolve(path));
  }

  String _encode(Uri purl) =>
      Uri.encodeComponent(Uri.encodeComponent(purl.toString()));

  Future<T> _get<T>(Uri query) async {
    final response = await _dio.getUri<T>(query);
    return _assertSuccess(response);
  }

  Future<T> _post<T>(Uri query, {dynamic body}) async {
    final response = await _dio.postUri<T>(
      query,
      data: body,
      options: Options(contentType: ContentType.json.toString()),
    );
    return _assertSuccess(response);
  }

  Future<T> _put<T>(Uri query, {dynamic body}) async {
    final response = await _dio.putUri<T>(
      query,
      data: body,
      options: Options(contentType: ContentType.json.toString()),
    );
    return _assertSuccess(response);
  }

  T _assertSuccess<T>(Response<T> response) {
    if (response.statusCode != 200) {
      throw DioError(
        type: DioErrorType.RESPONSE,
        response: response,
        error: 'Received status ${response.statusCode}',
      );
    }

    return response.data;
  }
}
