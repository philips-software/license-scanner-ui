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
  String contesting;
  bool isConfirmed = false;
}
