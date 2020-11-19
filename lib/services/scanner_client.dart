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
import 'package:license_scanner_ui/model/file_fragment.dart';

import '../model/scan_result.dart';
import 'model_mapper.dart';

typedef StatsCallback = void Function(
    {int licenses, int errors, int contested});

/// License Scanner service client.
/// See https://github.com/philips-labs/license-scanner
class ScannerClient {
  final baseUrl = Uri.http(kIsWeb && !kDebugMode ? '' : 'localhost:8080', '/');
  final _dio = Dio();

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
      sink.add(ScanResultMapper.fromPurlList(json['results']));
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

  Future<ScanResult> scanResultByUuid(String uuid) async {
    final json =
        await _get<Map<String, dynamic>>(baseUrl.resolve('scans/$uuid'));
    return ScanResultMapper.fromMap(json);
  }

  Future<ScanResult> scanResultByPackage(Uri purl) async {
    final path = 'packages/${_encode(purl)}';
    final json = await _get<Map<String, dynamic>>(baseUrl.resolve(path));
    return ScanResultMapper.fromMap(json);
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
    final path = 'scans/$scanId/ignore/$license?revert=${!ignore}';
    await _post(baseUrl.resolve(path));
  }

  Future<FileFragment> sourceFor(String scanId, String license,
      {int margin = 5}) async {
    final path = 'scans/$scanId/source/$license?margin=$margin';
    final json = await _get(baseUrl.resolve(path));
    //TODO Just for debugging
    log(json.toString());
    return FileFragmentMapper.fromMap(json);
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

  void _reportStats(StatsCallback callback, Map<String, dynamic> result) {
    callback?.call(
      licenses: result['licenses'],
      errors: result['errors'],
      contested: result['contested'],
    );
  }
}
