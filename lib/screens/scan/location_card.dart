/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/scan_result.dart';
import '../../screens/widgets/shared.dart';
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

    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(Icons.location_pin),
          title: Text('VCS Location'),
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
                    hintText: locationHint,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _openWebPage(_controller.text),
              ),
            ],
          ),
        ),
        ButtonBar(
          children: [
            TextButton.icon(
              icon: Icon(Icons.repeat),
              label: Text('RESCAN'),
              onPressed: () => service
                  .rescan(widget.scan.purl, _controller.text)
                  .then((_) => Navigator.of(context).pop())
                  .catchError((e) => showError(context, e.toString())),
            ),
          ],
        )
      ]),
    );
  }

  void _openWebPage(String text) async {
    final url = _webUrlFrom(text).toString();
    log('Opening $url');
    if (await canLaunch(url)) {
      launch(url).catchError((e) => showError(context, e));
    }
  }

  Uri _webUrlFrom(String vcsUri) {
    final at = vcsUri.indexOf('@');
    if (at > 0) {
      vcsUri = vcsUri.substring(0, at);
    }
    final url = Uri.parse(Uri.decodeFull(vcsUri));

    return Uri(scheme: 'https', host: url.host, path: url.path);
  }
}
