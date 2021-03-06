/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/model/detection.dart';
import 'package:license_scanner_ui/screens/widgets/shared.dart';
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
    _updateLicense();
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
                  _updateLicense();
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
                TextButton.icon(
                  icon: Icon(Icons.clear),
                  label: Text('CLEAR ALL'),
                  onPressed: () => Future.forEach<Detection>(
                          widget.scan.detections.where((det) => !det.ignored),
                          (det) => service.ignore(widget.scan, det))
                      .then((_) => setState(() => _updateLicense()))
                      .catchError((error) => showError(context, error)),
                ),
                TextButton.icon(
                  icon: Icon(Icons.verified),
                  label: Text('CONFIRM'),
                  onPressed: () => service
                      .confirm(widget.scan, license)
                      .then((_) => Navigator.pop(context))
                      .catchError((error) => showError(context, error)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _updateLicense() {
    final licenses =
        widget.scan.detections.where((d) => !d.ignored).map((d) => d.license);
    license = (licenses.length == 1)
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
