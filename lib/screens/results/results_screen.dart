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

import '../../services/scan_service.dart';
import 'scans_view.dart';

class ResultsScreen extends StatefulWidget {
  static const titles = [
    'Scanning errors',
    'Contested licenses',
    'Latest scans'
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
            icon: Icon(Icons.error_outline),
            activeIcon: Icon(Icons.error),
            label: 'Errors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            activeIcon: Icon(Icons.warning),
            label: 'Contested',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Latest',
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
    final service = Provider.of<ScanService>(context, listen: false);

    switch (index) {
      case 0:
        return ScansView(query: service.errors);
      case 1:
        return ScansView(query: service.contested);
      default:
        return ScansView(query: service.latest);
    }
  }
}
