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
import 'package:license_scanner_ui/screens/search/search_screen.dart';
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
    final service = Provider.of<ScanService>(context, listen: false);

    return PlatformTabScaffold(
      appBarBuilder: (context, index) => PlatformAppBar(
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
      tabController: PlatformTabController(),
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
      bodyBuilder: (_, index) {
        switch (index) {
          case 0:
            return ScansView(query: service.errors);
          case 1:
            return ScansView(query: service.contested);
          default:
            return ScansView(query: service.latest);
        }
      },
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
        applicationLegalese:
            'Copyright © 2020-2020 Koninklijke Philips N.V\nAll Rights Reserved');
  }

  void _search(BuildContext context) => Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => SearchScreen(),
      ));
}
