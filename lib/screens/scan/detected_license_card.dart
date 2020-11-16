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
import '../../services/scan_service.dart';
import 'detections_carousel.dart';

class DetectedLicenseCard extends StatefulWidget {
  DetectedLicenseCard(this.scan);

  final ScanResult scan;

  @override
  _DetectedLicenseCardState createState() => _DetectedLicenseCardState();
}

class _DetectedLicenseCardState extends State<DetectedLicenseCard> {
  var license = '';

  @override
  void initState() {
    super.initState();
    license = _detectedLicense();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return Material(
      type: MaterialType.transparency,
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Detected license'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DetectionsCarousel(
                widget.scan,
                onDetectionChange: () => setState(() {
                  license = _detectedLicense();
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (license.isNotEmpty)
                  ? Text(license, style: Theme.of(context).textTheme.headline6)
                  : Text('(No license detected)',
                      style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: Text('CLEAR ALL'),
                  onPressed: () => widget.scan.detections.forEach(
                      (det) => service.ignore(widget.scan, det.license)),
                ),
                TextButton(
                  child: Text('CONFIRM'),
                  onPressed: license.isEmpty
                      ? null
                      : () {
                          service
                              .confirm(widget.scan, license)
                              .then((_) => Navigator.pop(context));
                        },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _detectedLicense() {
    final licenses =
        widget.scan.detections.where((d) => !d.ignored).map((d) => d.license);
    return (licenses.length == 1)
        ? licenses.first
        : licenses
            .map((lic) => _isCombinedExpression(lic) ? '($lic)' : lic)
            .join(' AND ');
  }

  bool _isCombinedExpression(String license) {
    final lower = license.toLowerCase();
    return lower.contains(' and ') || lower.contains(' or ');
  }
}
