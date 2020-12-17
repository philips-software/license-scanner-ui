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

class ManualLicenseCard extends StatefulWidget {
  ManualLicenseCard(this.scan);

  final ScanResult scan;

  @override
  _ManualLicenseCardState createState() => _ManualLicenseCardState();
}

class _ManualLicenseCardState extends State<ManualLicenseCard> {
  final _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.scan.isConfirmed) {
      _controller.text = widget.scan.license;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(Icons.verified),
          title: Text('Manual license override'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            onChanged: (_) => setState(() => null),
          ),
        ),
        if (widget.scan.isConfirmed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.thumb_up_outlined, color: Colors.blue),
                Text('Confirmed license: ${widget.scan.license}',
                    style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ButtonBar(children: [
          TextButton.icon(
            icon: Icon(Icons.verified),
            label: Text('CONFIRM'),
            onPressed: (_controller.text != widget.scan.license)
                ? () => _confirmLicense(context, _controller.text)
                : null,
          ),
        ])
      ]),
    );
  }

  Future<void> _confirmLicense(BuildContext context, String license) {
    final service = ScanService.of(context);

    return service
        .confirm(widget.scan, license)
        .then((_) => Navigator.pop(context))
        .catchError((e) => showError(context, e));
  }
}
