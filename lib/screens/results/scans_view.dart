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
import 'package:provider/provider.dart';

import '../../model/scan_result.dart';
import '../../services/scan_service.dart';
import '../widgets/snapshot_view.dart';
import 'scan_list.dart';

class ScansView extends StatefulWidget {
  ScansView({this.query}) : super(key: GlobalObjectKey(query));

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
            final uuid = scan.id;
            await Navigator.pushNamed(context, '/scan',
                arguments: service.getScanResult(uuid));
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
