/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

class ScanResult {
  ScanResult({this.uuid, this.purl});

  final String uuid;
  final Uri purl;

  String license = '';
  String location;
  String error;
  List<Detection> detections;

  bool isContested = false;
  bool isConfirmed = false;

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    final result = ScanResult(
      uuid: map['id'],
      purl: Uri.parse(map['purl']),
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

  static List<ScanResult> fromList(List<dynamic> list) =>
      list.map((m) => ScanResult.fromMap(m)).toList(growable: false);

  static List<Uri> fromPurlList(List<dynamic> list) =>
      list.map((uri) => Uri.parse(uri)).toList(growable: false);
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
