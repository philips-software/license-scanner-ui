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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:license_scanner_ui/screens/widgets/snapshot_view.dart';

import '../../services/scan_result.dart';
import 'detections_card.dart';
import 'error_card.dart';
import 'info_card.dart';
import 'license_card.dart';
import 'location_card.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScanScreenParams params = ModalRoute.of(context).settings.arguments;

    return PlatformScaffold(
      iosContentPadding: true,
      iosContentBottomPadding: true,
      appBar: PlatformAppBar(title: Text('Scan result')),
      body: FutureBuilder(
        future: params.future,
        builder: (context, snapshot) {
          return SnapshotView(
            snapshot,
            builder: (scan) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InfoCard(scan),
                  if (scan.error != null) ErrorCard(scan),
                  if (scan.detections.isNotEmpty) DetectionsCard(scan),
                  LicenseCard(scan),
                  LocationCard(scan),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ScanScreenParams {
  final Future<ScanResult> future;

  ScanScreenParams(this.future);
}
