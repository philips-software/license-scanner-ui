/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/scan_result.dart';
import '../../services/scan_service.dart';
import '../scan/scan_screen.dart';
import '../widgets/exception_widget.dart';
import '../widgets/scan_widget.dart';

class LatestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Latest scans'), actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'License Scanner',
              applicationLegalese: 'Licensed under MIT'),
        ),
      ]),
      body: StreamBuilder(
        stream: service.lastScanned,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ExceptionWidget(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return _scans(snapshot.data, service);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        tooltip: 'Search package',
        onPressed: () => Navigator.pushNamed(context, 'search'),
      ),
    );
  }

  RefreshIndicator _scans(List<ScanResult> data, ScanService service) {
    return RefreshIndicator(
      child: Scrollbar(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => ScanWidget(
            data[index],
            onTap: () {
              final scan = data[index];
              final uuid = scan.uuid;
              final args = ScanScreenParams(scan, service.getScanResult(uuid));
              return Navigator.of(context).pushNamed('scan', arguments: args);
            },
          ),
        ),
      ),
      onRefresh: () => service.refreshScans(),
    );
  }
}
