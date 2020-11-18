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
import 'package:intl/intl.dart';

import '../../model/scan_result.dart';

class ScanResultTile extends StatelessWidget {
  static final dateFormat = DateFormat.yMMMMEEEEd().add_Hm();

  ScanResultTile(this.scan, {this.onTap});

  final ScanResult scan;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: _iconFor(scan),
          title: Text(scan.purl.toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scan.license.isNotEmpty)
                Text(
                  '${scan.license}',
                ),
              if (scan.timestamp != null)
                Text('Scanned: ${dateFormat.format(scan.timestamp)}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              if (scan.error != null)
                Text(
                  scan.error,
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  static Icon _iconFor(ScanResult scan) {
    if (scan.license == null) {
      return Icon(Icons.source);
    }
    if (scan.error != null) {
      return Icon(Icons.warning, color: Colors.red);
    }
    if (scan.isConfirmed) {
      return Icon(Icons.verified, color: Colors.green);
    }
    if (scan.contesting != null) {
      return Icon(Icons.help, color: Colors.orange);
    }
    return Icon(Icons.check_circle, color: Colors.blue);
  }
}
