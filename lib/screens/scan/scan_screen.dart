/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/screens/scan/contest_card.dart';

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
            return SnapshotView<ScanResult>(
              snapshot,
              builder: (scan) => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoCard(scan),
                    if (scan.error != null) ErrorCard(scan),
                    if (scan.detections.isNotEmpty) DetectedLicenseCard(scan),
                    if (scan.contesting != null) ContestCard(scan),
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
