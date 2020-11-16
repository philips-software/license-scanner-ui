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
import 'package:provider/provider.dart';

import '../../model/scan_result.dart';
import '../../screens/widgets/shared.dart';
import '../../services/scan_service.dart';

class DeclaredLicenseCard extends StatefulWidget {
  DeclaredLicenseCard(this.scan);

  final ScanResult scan;

  @override
  _DeclaredLicenseCardState createState() => _DeclaredLicenseCardState();
}

class _DeclaredLicenseCardState extends State<DeclaredLicenseCard> {
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
          title: Text('Declared license'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            autofocus: true,
          ),
        ),
        if (widget.scan.isContested)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              Text('License was contested',
                  style: TextStyle(color: Colors.orange)),
            ]),
          ),
        if (widget.scan.isConfirmed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(Icons.thumb_up_outlined, color: Colors.blue),
              Text('License was confirmed',
                  style: TextStyle(color: Colors.blue)),
            ]),
          ),
        ButtonBar(children: [
          TextButton(
            child: Text('CONFIRM'),
            onPressed: () => service
                .confirm(widget.scan, _controller.text)
                .whenComplete(() => Navigator.pop(context))
                .catchError((e) => showError(context, e.toString())),
          ),
        ])
      ]),
    );
  }
}
