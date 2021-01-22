/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:license_scanner_ui/model/detection.dart';
import 'package:license_scanner_ui/model/file_fragment.dart';
import 'package:license_scanner_ui/model/scan_result.dart';

extension DetectionMapper on Detection {
  static Detection fromMap(Map<String, dynamic> map) {
    return Detection(
      license: map['license'],
      file: map['file'] ?? '?',
      startLine: map['start_line'] ?? 0,
      endLine: map['end_line'] ?? 0,
      confirmations: map['confirmations'] ?? 0,
      ignored: map['ignored'] ?? false,
    );
  }
}

extension FileFragmentMapper on FileFragment {
  static FileFragment fromMap(Map<String, dynamic> map) {
    return FileFragment(
      filename: map['file'] ?? '?',
      offset: map['first'] ?? 0,
      startLine: map['start'] ?? 1,
      endLine: map['end'] ?? 1,
      lines: (map['lines'] as List)?.map((l) => l as String)?.toList() ?? [],
    );
  }
}

extension ScanResultMapper on ScanResult {
  static ScanResult fromMap(Map<String, dynamic> map) {
    final result = ScanResult(
      id: map['id'],
      purl: Uri.parse(map['purl']),
      timestamp: DateTime.parse(map['timestamp']).toLocal(),
    );
    result.license = map['license'];
    result.location = map['location'];
    result.error = map['error'];
    result.isConfirmed = map['confirmed'];
    result.contesting = map['contesting'];
    final List<dynamic> detections = map['detections'];
    if (detections != null) {
      result.detections =
          detections.map((map) => DetectionMapper.fromMap(map)).toList();
    }

    return result;
  }

  static List<ScanResult> fromList(List<dynamic> list) =>
      list.map((m) => fromMap(m)).toList(growable: false);
}
