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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../services/scan_service.dart';
import '../widgets/snapshot_view.dart';
import 'names_filter.dart';
import 'search_results.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _service = Provider.of<ScanService>(context, listen: false);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            NamesFilter(onFilter: (ns, name) => _service.search(ns, name)),
            Expanded(
              child: StreamBuilder(
                stream: _service.lastSearched,
                initialData: <Uri>[],
                builder: (context, snapshot) => SnapshotView(
                  snapshot,
                  builder: (list) => (list.isEmpty)
                      ? Center(child: Text('(No matches found)'))
                      : SearchResults(list),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
