/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../screens/widgets/shared.dart';
import '../../services/scan_result.dart';
import '../../services/scan_service.dart';

class LocationCard extends StatefulWidget {
  final ScanResult scan;

  LocationCard(this.scan);

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  final _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.scan.location;
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
          leading: Icon(Icons.location_pin),
          title: Text('Location'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: '[<vcs>+]<url>[@<version>][#<path>]',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () => Clipboard.setData(
                    new ClipboardData(text: _controller.text)),
              ),
            ],
          ),
        ),
        ButtonBar(
          children: [
            RaisedButton.icon(
              icon: Icon(Icons.repeat),
              label: Text('RESCAN'),
              onPressed: () => service
                  .rescan(widget.scan, _controller.text)
                  .whenComplete(() => Navigator.of(context).pop())
                  .catchError((e) => showError(context, e.toString())),
            ),
          ],
        )
      ]),
    );
  }
}
