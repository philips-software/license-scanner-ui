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
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../services/scan_service.dart';

class SearchResults extends StatelessWidget {
  SearchResults(this.packages);

  final List<Uri> packages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final purl = packages[index];
          final service = Provider.of<ScanService>(context, listen: false);

          return ListTile(
            leading: Icon(Icons.source),
            title: Text(purl.toString()),
            onTap: () {
              Navigator.pushNamed(context, '/scan',
                  arguments: service.getPackageScanResult(purl));
            },
          );
        });
  }
}
