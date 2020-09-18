import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';

class ErrorCard extends StatelessWidget {
  final ScanResult scan;

  ErrorCard(this.scan);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(
            Icons.warning,
            color: Colors.red,
          ),
          title: Text('Error'),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            scan.error,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ]),
    );
  }
}
