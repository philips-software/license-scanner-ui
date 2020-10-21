/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:license_scanner_ui/screens/scan/scan_screen.dart';
import 'package:license_scanner_ui/screens/widgets/snapshot_view.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:provider/provider.dart';

import 'scan_list.dart';

class ScansView extends StatelessWidget {
  ScansView({this.scans});

  final Future<List<ScanResult>> scans;

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return FutureBuilder(
      future: scans,
      builder: (context, snapshot) => SnapshotView(
        snapshot,
        builder: (list) => ScanList(
          list,
          onTap: (scan) {
            final uuid = scan.uuid;
            final args = ScanScreenParams(scan, service.getScanResult(uuid));
            Navigator.push(
                context,
                platformPageRoute(
                    context: context,
                    builder: (context) => ScanScreen(),
                    settings: RouteSettings(arguments: args)));
          },
          onRefresh: () => service.refreshScans(),
        ),
      ),
    );
  }
}
