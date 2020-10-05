/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/widgets/shared.dart';
import '../../services/scan_result.dart';
import '../../services/scan_service.dart';

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
          if (widget.scan.isContested)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange),
                Text('License was contested',
                    style: TextStyle(color: Colors.orange)),
              ]),
            ),
          RaisedButton.icon(
            icon: Icon(Icons.verified),
            label: Text('CONFIRM'),
            onPressed: () => service
                .confirm(widget.scan.uuid, _controller.text)
                .whenComplete(() => Navigator.of(context).pop())
                .catchError((e) => showError(context, e.toString())),
          ),
        ])
      ]),
    );
  }
}
