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
import 'package:license_scanner_ui/services/detection.dart';

class DetectionCard extends StatelessWidget {
  DetectionCard(this.detection, {this.onIgnore});

  final Detection detection;
  final Function(Detection detection) onIgnore;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: Column(
          children: [
            Text(
              detection.license,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.text_snippet_outlined),
              title: Text('file: ${detection.file}'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.format_line_spacing),
              title: Text((detection.startLine != detection.endLine)
                  ? 'line ${detection.startLine} - ${detection.endLine} (${1 + detection.endLine - detection.startLine} lines)'
                  : 'line ${detection.startLine}'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.thumb_up_outlined),
              title: Text((detection.confirmations > 1)
                  ? 'found in ${detection.confirmations} locations'
                  : '(single detection)'),
              dense: true,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('False-positive'),
              Switch(
                value: detection.ignored,
                onChanged: (value) => onIgnore(detection),
              ),
            ]),
          ],
        ),
        elevation: 10,
        color: Colors.grey[50],
      ),
    );
  }
}
