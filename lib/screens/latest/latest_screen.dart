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

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Latest scans'),
        leading: PlatformIconButton(
          icon: Icon(PlatformIcons(context).info),
          onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'License Scanner',
              applicationLegalese: 'Licensed under MIT'),
        ),
        cupertino: (context, __) => CupertinoNavigationBarData(
          trailing: PlatformIconButton(
            icon: Icon(PlatformIcons(context).search),
            onPressed: () => _search(context),
          ),
        ),
      ),
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
      material: (_, __) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          tooltip: 'Search package',
          onPressed: () => _search(context),
        ),
      ),
    );
  }

  void _search(BuildContext context) => Navigator.pushNamed(context, 'search');

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
