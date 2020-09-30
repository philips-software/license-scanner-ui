/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

class ScanResult {
  final String uuid;
  final String namespace;
  final String name;
  final String version;

  String license = '';
  String location;
  String error;
  List<Detection> detections;

  bool isContested = false;
  bool isConfirmed = false;

  ScanResult(this.uuid, this.namespace, this.name, this.version);

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    final result = ScanResult(
      map['id'],
      map['namespace'] ?? '',
      map['name'],
      map['version'],
    );
    result.license = map['license'];
    result.location = map['location'];
    result.error = map['error'];
    result.isConfirmed = map['confirmed'];
    result.isContested = map['contested'];
    final List<dynamic> detections = map['detections'];
    if (detections != null) {
      result.detections =
          detections.map((map) => Detection.fromMap(map)).toList();
    }

    return result;
  }
}

class Detection {
  final String license;
  final String file;
  final int startLine;
  final int endLine;
  final int confirmations;

  Detection(this.license, this.file, this.startLine, this.endLine,
      this.confirmations);

  factory Detection.fromMap(Map<String, dynamic> map) {
    return Detection(
      map['license'],
      map['file'] ?? '?',
      map['start_line'] ?? 0,
      map['end_line'] ?? 0,
      map['confirmations'] ?? 0,
    );
  }
}
