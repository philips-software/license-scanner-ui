/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';

import 'detections_carousel.dart';

class DetectionsCard extends StatelessWidget {
  final ScanResult scan;

  DetectionsCard(this.scan);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Detections'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DetectionsCarousel(scan.detections),
          ),
        ],
      ),
    );
  }
}
