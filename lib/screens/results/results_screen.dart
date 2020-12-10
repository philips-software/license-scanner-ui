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
import 'package:license_scanner_ui/screens/widgets/icon_badge.dart';
import 'package:provider/provider.dart';

import '../../services/scan_service.dart';
import 'scans_view.dart';

class ResultsScreen extends StatefulWidget {
  static const titles = [
    'Latest scans',
    'Contested licenses',
    'Scanning errors',
  ];

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ResultsScreen.titles[_index]),
        leading: IconButton(
          icon: Icon(Icons.info),
          onPressed: () => _showAboutDialog(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: _body(context, _index),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _statusIcon(
              Icons.history_outlined,
              builder: (service) => service.licenseCount,
              color: Colors.blue,
            ),
            activeIcon: _statusIcon(
              Icons.history,
              builder: (service) => service.licenseCount,
              color: Colors.blue,
            ),
            label: 'Latest',
          ),
          BottomNavigationBarItem(
            icon: _statusIcon(
              Icons.warning_amber_outlined,
              builder: (service) => service.contestCount,
              color: Colors.orange,
            ),
            activeIcon: _statusIcon(
              Icons.warning,
              builder: (service) => service.contestCount,
              color: Colors.orange,
            ),
            label: 'Contested',
          ),
          BottomNavigationBarItem(
            icon: _statusIcon(
              Icons.error_outline,
              builder: (service) => service.errorCount,
              color: Colors.red,
            ),
            activeIcon: _statusIcon(
              Icons.error,
              builder: (service) => service.errorCount,
              color: Colors.red,
            ),
            label: 'Errors',
          ),
        ],
        currentIndex: _index,
        onTap: (index) => setState(() {
          _index = index;
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        tooltip: 'Search package',
        onPressed: () => Navigator.pushNamed(context, '/search'),
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

  Widget _body(BuildContext context, int index) {
    final service = ScanService.of(context);

    switch (index) {
      case 0:
        return ScansView(query: service.latest);
      case 1:
        return ScansView(query: service.contested);
      default:
        return ScansView(query: service.errors);
    }
  }

  Widget _statusIcon(IconData icon,
      {int Function(ScanService) builder, Color color}) {
    return Consumer<ScanService>(
      builder: (_, service, __) => IconBadge(
        icon,
        value: _toLabel(builder(service)),
        color: color,
      ),
    );
  }

  String _toLabel(int value) => (value > 0) ? value.toString() : null;
}
