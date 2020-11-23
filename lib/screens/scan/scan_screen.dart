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

import '../../model/scan_result.dart';
import '../widgets/snapshot_view.dart';
import 'detected_license_card.dart';
import 'error_card.dart';
import 'info_card.dart';
import 'location_card.dart';
import 'manual_license_card.dart';

class ScanScreen extends StatelessWidget {
  ScanScreen(this.future);

  final Future<ScanResult> future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan result')),
      body: SafeArea(
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return SnapshotView(
              snapshot,
              builder: (scan) => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoCard(scan),
                    if (scan.error != null) ErrorCard(scan),
                    if (scan.detections.isNotEmpty) DetectedLicenseCard(scan),
                    ManualLicenseCard(scan),
                    LocationCard(scan),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ScanScreenParams {
  final Future<ScanResult> future;

  ScanScreenParams(this.future);
}
