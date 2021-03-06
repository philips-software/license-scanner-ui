/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/model/scan_result.dart';

import '../../model/detection.dart';

class DetectionView extends StatelessWidget {
  DetectionView(this.scan, this.detection, {this.onIgnore});

  final ScanResult scan;
  final Detection detection;
  final Function(Detection detection) onIgnore;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        key: ValueKey(this.detection.license),
        child: Column(
          children: [
            Text(
              detection.license,
              textAlign: TextAlign.center,
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
              trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Navigator.pushNamed(context, '/source',
                    arguments: {
                      'scan': scan,
                      'filename': detection.file,
                      'license': detection.license
                    }),
              ),
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
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[50]
            : Colors.blueGrey[900],
      ),
    );
  }
}
