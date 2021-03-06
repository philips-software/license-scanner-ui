/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:license_scanner_ui/model/file_fragment.dart';

import '../model/scan_result.dart';
import 'model_mapper.dart';

typedef StatsCallback = void Function(
    {int licenses, int errors, int contested});

/// License Scanner service client.
/// See https://github.com/philips-internal/license-scanner
class ScannerClient {
  final baseUrl = Uri.http(kIsWeb && !kDebugMode ? '' : 'localhost:8080', '/');
  final _dio = Dio();

  /// Queries for named package, reporting results and errors in the [sink].
  void search(
      StreamSink<List<ScanResult>> sink, String namespace, String name) async {
    _catchErrorsToSink(sink, () async {
      final json =
          await _get<Map<String, dynamic>>(baseUrl.resolve('packages').replace(
        queryParameters: {
          'namespace': _encoded(namespace),
          'name': _encoded(name),
        },
      ));
      sink.add(ScanResultMapper.fromList(json['results']));
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

  Future<List<ScanResult>> latestScanResults([StatsCallback callback]) async {
    final json = await _get<Map<String, dynamic>>(baseUrl.resolve('scans'));
    _reportStats(callback, json);
    return ScanResultMapper.fromList(json['results']);
  }

  Future<List<ScanResult>> scanErrors([StatsCallback callback]) async {
    final json =
        await _get<Map<String, dynamic>>(baseUrl.resolve('scans').replace(
      queryParameters: {'q': 'errors'},
    ));
    _reportStats(callback, json);
    return ScanResultMapper.fromList(json['results']);
  }

  Future<List<ScanResult>> contested([StatsCallback callback]) async {
    final json =
        await _get<Map<String, dynamic>>(baseUrl.resolve('scans').replace(
      queryParameters: {'q': 'contested'},
    ));
    _reportStats(callback, json);
    return ScanResultMapper.fromList(json['results']);
  }

  Future<ScanResult> getScanResult(String scanId) async {
    final json = await _get<Map<String, dynamic>>(
        baseUrl.resolve('scans/${_encoded(scanId)}'));
    return ScanResultMapper.fromMap(json);
  }

  Future<void> rescan(Uri purl, String location) async {
    final path = 'packages';
    final body = {'purl': purl.toString(), 'location': location};
    await _post(
      baseUrl.resolve(path).replace(
        queryParameters: {'force': 'yes'},
      ),
      body: body,
    );
  }

  Future<void> confirm(String scanId, String license) async {
    final body = {'license': license};
    await _put(baseUrl.resolve('scans/${_encoded(scanId)}'), body: body);
  }

  Future<void> ignore(String scanId, String license,
      {bool ignore = true}) async {
    final path = 'scans/${_encoded(scanId)}/ignore/$license?revert=${!ignore}';
    await _post(baseUrl.resolve(path));
  }

  Future<void> delete(String scanId) async {
    await _delete(baseUrl.resolve('scans/${_encoded(scanId)}'));
  }

  Future<FileFragment> sourceFor(String scanId, String license,
      {int margin = 5}) async {
    final path = 'scans/${_encoded(scanId)}/source/$license?margin=$margin';
    final json = await _get(baseUrl.resolve(path));
    return FileFragmentMapper.fromMap(json);
  }

  Future<T> _get<T>(Uri query) async {
    final response = await _dio.getUri<T>(query);
    return response.data;
  }

  Future<T> _post<T>(Uri query, {dynamic body}) async {
    final response = await _dio.postUri<T>(
      query,
      data: body,
      options: Options(contentType: ContentType.json.toString()),
    );
    return response.data;
  }

  Future<T> _put<T>(Uri query, {dynamic body}) async {
    final response = await _dio.putUri<T>(
      query,
      data: body,
      options: Options(contentType: ContentType.json.toString()),
    );
    return response.data;
  }

  Future<void> _delete(Uri query) => _dio.deleteUri(query);

  void _reportStats(StatsCallback callback, Map<String, dynamic> result) {
    callback?.call(
      licenses: result['licenses'],
      errors: result['errors'],
      contested: result['contested'],
    );
  }

  String _encoded(String string) => Uri.encodeComponent(string);
}
