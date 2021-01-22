/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:license_scanner_ui/screens/widgets/shared.dart';
import 'package:license_scanner_ui/services/scan_service.dart';

import '../../model/scan_result.dart';

class InfoCard extends StatelessWidget {
  static final dateFormat = DateFormat.yMMMMEEEEd().add_Hm();

  InfoCard(this.scan);

  final ScanResult scan;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info),
            title: Text(scan.purl.toString(), style: TextStyle(fontSize: 20)),
            subtitle: Text('Scanned: ${dateFormat.format(scan.timestamp)}'),
          ),
          ButtonBar(
            children: [
              TextButton.icon(
                icon: Icon(Icons.delete, color: Colors.red),
                label: Text("DELETE", style: TextStyle(color: Colors.red)),
                onPressed: () => ScanService.of(context)
                    .delete(scan)
                    .then((_) => Navigator.of(context).pop())
                    .catchError((e) => showError(context, e.toString())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
