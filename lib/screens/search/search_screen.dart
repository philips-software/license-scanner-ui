/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/model/scan_result.dart';
import 'package:license_scanner_ui/screens/widgets/scan_result_tile.dart';
import 'package:provider/provider.dart';

import '../../services/scan_service.dart';
import '../widgets/snapshot_view.dart';
import 'names_filter.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            NamesFilter(onFilter: (ns, name) => service.search(ns, name)),
            Expanded(
              child: StreamBuilder<List<ScanResult>>(
                stream: service.lastSearched,
                initialData: [],
                builder: (context, snapshot) => SnapshotView<List<ScanResult>>(
                  snapshot,
                  builder: (scans) => (scans.isEmpty)
                      ? Center(child: Text('(No matches found)'))
                      : ListView.builder(
                          itemCount: scans.length,
                          itemBuilder: (context, index) {
                            final scan = scans[index];
                            return ScanResultTile(
                              scan,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/scan',
                                arguments: service.getScanResult(scan.id),
                              ),
                            );
                          }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
