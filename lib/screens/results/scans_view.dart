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

class ScansView extends StatefulWidget {
  ScansView({this.query});

  final Future<List<ScanResult>> Function() query;

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  Future<List<ScanResult>> future;

  @override
  void initState() {
    super.initState();
    future = widget.query();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => SnapshotView(
        snapshot,
        builder: (list) => ScanList(
          list,
          onTap: (scan) async {
            final uuid = scan.uuid;
            final args = ScanScreenParams(service.getScanResult(uuid));
            await Navigator.push(
                context,
                platformPageRoute(
                    context: context,
                    builder: (context) => ScanScreen(),
                    settings: RouteSettings(arguments: args)));
            _refresh();
          },
          onRefresh: () {
            _refresh();
            return future;
          },
        ),
      ),
    );
  }

  void _refresh() {
    setState(() {
      future = widget.query();
    });
  }
}
