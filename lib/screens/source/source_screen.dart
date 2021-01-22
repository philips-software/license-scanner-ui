/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/model/file_fragment.dart';
import 'package:license_scanner_ui/model/scan_result.dart';
import 'package:license_scanner_ui/screens/widgets/snapshot_view.dart';
import 'package:license_scanner_ui/services/scan_service.dart';

import 'fragment_view.dart';

class SourceScreen extends StatefulWidget {
  SourceScreen(this.scan, this.filename, this.license);

  final ScanResult scan;
  final String filename;
  final String license;

  @override
  _SourceScreenState createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final service = ScanService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detection source'),
        actions: [
          IconButton(
            icon: Icon(expanded ? Icons.compress : Icons.expand),
            onPressed: () => setState(() {
              expanded = !expanded;
            }),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.filename,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: FutureBuilder<FileFragment>(
              future: service.detectionSource(
                  widget.scan, widget.license, expanded ? 10000 : 5),
              builder: (context, snapshot) => SnapshotView<FileFragment>(
                snapshot,
                message: 'Downloading package source files...',
                builder: (fragment) => FragmentView(fragment),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
