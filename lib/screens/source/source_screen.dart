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
import 'package:license_scanner_ui/model/file_fragment.dart';
import 'package:license_scanner_ui/model/scan_result.dart';
import 'package:license_scanner_ui/screens/widgets/snapshot_view.dart';
import 'package:license_scanner_ui/services/scan_service.dart';

class SourceScreen extends StatelessWidget {
  SourceScreen(this.scan, this.license);

  final ScanResult scan;
  final String license;

  @override
  Widget build(BuildContext context) {
    final service = ScanService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detection source'),
      ),
      body: FutureBuilder<FileFragment>(
        future: service.detectionSource(scan, license, 5),
        builder: (context, snapshot) => SnapshotView<FileFragment>(
          snapshot,
          builder: (fragment) => ListView.builder(
            itemCount: fragment.lines.length,
            itemBuilder: (context, index) => Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text('${fragment.offset + index}'),
                ),
                Expanded(
                  child: Text(
                    fragment.lines[index],
                    style: TextStyle(
                        backgroundColor: (index >= fragment.startLine &&
                                index < fragment.endLine)
                            ? Colors.yellow
                            : null),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
