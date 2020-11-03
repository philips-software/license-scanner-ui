/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import '../model/detection.dart';

class ScanResult {
  ScanResult({this.uuid, this.purl, this.timestamp});

  final String uuid;
  final Uri purl;
  final DateTime timestamp;

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
      timestamp: DateTime.parse(map['timestamp']),
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
