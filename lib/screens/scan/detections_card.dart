/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'package:flutter/material.dart';

import '../../services/scan_result.dart';
import 'detections_carousel.dart';

class DetectionsCard extends StatelessWidget {
  final ScanResult scan;

  DetectionsCard(this.scan);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Detections'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DetectionsCarousel(scan),
            ),
          ],
        ),
      ),
    );
  }
}
