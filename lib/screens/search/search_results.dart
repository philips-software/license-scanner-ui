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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:license_scanner_ui/screens/scan/scan_screen.dart';
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:provider/provider.dart';

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

          return Material(
            child: ListTile(
              leading: Icon(Icons.source),
              title: Text(purl.toString()),
              onTap: () {
                final params =
                    ScanScreenParams(service.getPackageScanResult(purl));
                Navigator.push(
                    context,
                    platformPageRoute(
                        context: context,
                        builder: (_) => ScanScreen(),
                        settings: RouteSettings(arguments: params)));
              },
            ),
          );
        });
  }
}
