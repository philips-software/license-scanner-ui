/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import '../model/detection.dart';

class ScanResult {
  ScanResult({this.id, this.purl, this.timestamp});

  final String id;
  final Uri purl;
  final DateTime timestamp;

  String license = '';
  String location;
  String error;
  List<Detection> detections;
  String contesting;
  bool isConfirmed = false;
}
