import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:license_scanner_ui/widgets/shared.dart';
import 'package:provider/provider.dart';

import 'scan_screen.dart';

class LicenseCard extends StatefulWidget {
  final ScanResult scan;

  LicenseCard(this.scan);

  @override
  _LicenseCardState createState() => _LicenseCardState();
}

class _LicenseCardState extends State<LicenseCard> {
  final _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.scan.license;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScanService service = Provider.of<ScanService>(context);

    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(Icons.verified),
          title: Text('License'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            autofocus: true,
          ),
        ),
        ButtonBar(children: [
          FlatButton.icon(
            icon: Icon(Icons.verified),
            label: Text('CONFIRM'),
            onPressed: () => service
                .confirm(widget.scan.uuid, _controller.text)
                .whenComplete(() => Navigator.of(context).pushReplacementNamed(
                'scan',
                arguments: ScanScreenParams(
                    widget.scan, service.getScanResult(widget.scan.uuid))))
                .catchError((e) => showError(context, e.toString())),
          ),
        ])
      ]),
    );
  }
}
