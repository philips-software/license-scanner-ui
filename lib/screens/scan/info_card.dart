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
import 'package:license_scanner_ui/services/scan_result.dart';

class InfoCard extends StatelessWidget {
  InfoCard(this.scan);

  final ScanResult scan;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: Icon(PlatformIcons(context).info),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scan.name, style: style.headline4),
            if (scan.version.isNotEmpty) Text('Version ${scan.version}'),
            if (scan.namespace.isNotEmpty) Text(scan.namespace),
          ],
        ),
      ),
    );
  }
}
