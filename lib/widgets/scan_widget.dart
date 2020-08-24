import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';

class ScanWidget extends Card {
  final ScanResult scan;

  ScanWidget(this.scan)
      : super(
            child: ListTile(
          leading: Icon(Icons.check_circle),
          title: Text(title(scan)),
          subtitle: Text('${scan.license}'),
        ));

  static String title(ScanResult scan) {
    final name = '${scan.name} ${scan.version}';
    return (scan.namespace.isEmpty) ? name : name + ' (${scan.namespace})';
  }
}
