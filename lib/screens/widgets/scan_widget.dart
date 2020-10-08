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

import '../../services/scan_result.dart';

class ScanWidget extends StatelessWidget {
  final ScanResult scan;
  final Function onTap;

  ScanWidget(this.scan, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _iconFor(scan),
      title: Text(title(scan)),
      subtitle: (scan.error == null)
          ? Text(scan.license ?? '')
          : Text(
              scan.error,
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
      onTap: onTap,
    );
  }

  static String title(ScanResult scan) {
    final name = '${scan.name} ${scan.version}';
    return (scan.namespace.isEmpty) ? name : name + ' (${scan.namespace})';
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
    if (scan.isContested) {
      return Icon(Icons.help, color: Colors.orange);
    }
    return Icon(Icons.check_circle, color: Colors.blue);
  }
}
