import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';

class ScanWidget extends Card {
  final ScanResult scan;

  ScanWidget(this.scan)
      : super(
            child: ListTile(
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
        ));

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
      return Icon(Icons.verified, color: Colors.blue);
    }
    if (scan.isContested) {
      return Icon(Icons.help, color: Colors.orange);
    }
    return Icon(Icons.check_circle, color: Colors.blue);
  }
}
