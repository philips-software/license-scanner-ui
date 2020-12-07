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

import '../../model/scan_result.dart';
import '../../screens/widgets/shared.dart';
import '../../services/scan_service.dart';

class ContestCard extends StatelessWidget {
  ContestCard(this.scan);

  final ScanResult scan;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(Icons.warning, color: Colors.orange),
          title: Text(
            'Contesting license',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        Text(
          scan.contesting.isNotEmpty
              ? scan.contesting
              : 'License was contested',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.orange),
        ),
        if (scan.contesting.isNotEmpty)
          ButtonBar(children: [
            TextButton(
              child: Text('CONFIRM'),
              onPressed: () => _confirmLicense(context, scan.contesting),
            ),
          ])
      ]),
    );
  }

  Future<void> _confirmLicense(BuildContext context, String license) {
    final service = ScanService.of(context);

    return service
        .confirm(scan, license)
        .whenComplete(() => Navigator.pop(context))
        .catchError((e) => showError(context, e.toString()));
  }
}
