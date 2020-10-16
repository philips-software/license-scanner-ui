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
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:provider/provider.dart';

import 'scans_view.dart';

class ResultsScreen extends StatelessWidget {
  static const titles = [
    'Scanning errors',
    'Contested licenses',
    'Latest scans'
  ];

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen:false);

    return PlatformTabScaffold(
      appBarBuilder: (_, index) => PlatformAppBar(
        title: Text(titles[index]),
        leading: PlatformIconButton(
          icon: Icon(PlatformIcons(context).info),
          onPressed: () => _showAboutDialog(context),
        ),
        cupertino: (context, __) => CupertinoNavigationBarData(
          trailing: PlatformIconButton(
            icon: Icon(PlatformIcons(context).search),
            onPressed: () => _search(context),
          ),
        ),
      ),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.error),
          label: 'Errors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning),
          label: 'Contested',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Latest',
        ),
      ],
      bodyBuilder: (_, index) => ScansView(scans: service.lastScanned,),
      material: (_, __) => MaterialTabScaffoldData(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          tooltip: 'Search package',
          onPressed: () => _search(context),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    return showAboutDialog(
        context: context,
        applicationName: 'License Scanner',
        applicationLegalese: 'Licensed under MIT');
  }

  void _search(BuildContext context) => Navigator.pushNamed(context, 'search');
}