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
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../screens/widgets/shared.dart';
import '../../model/scan_result.dart';
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
    const locationHint = '[<vcs>+]<url>[@<version>][#<path>]';
    final ScanService service = Provider.of<ScanService>(context);

    return Material(
      type: MaterialType.transparency,
      child: Card(
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
                  child: PlatformTextField(
                    controller: _controller,
                    material: (_, __) => MaterialTextFieldData(
                      decoration: InputDecoration(
                        hintText: locationHint,
                      ),
                    ),
                    cupertino: (_, __) => CupertinoTextFieldData(
                      placeholder: locationHint,
                    ),
                  ),
                ),
                PlatformIconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () => Clipboard.setData(
                      new ClipboardData(text: _controller.text)),
                ),
              ],
            ),
          ),
          ButtonBar(
            children: [
              PlatformButton(
                child: PlatformText('Rescan'),
                onPressed: () => service
                    .rescan(widget.scan.purl, _controller.text)
                    .whenComplete(() => Navigator.of(context).pop())
                    .catchError((e) => showError(context, e.toString())),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
