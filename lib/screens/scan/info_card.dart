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
import 'package:intl/intl.dart';
import '../../model/scan_result.dart';

class InfoCard extends StatelessWidget {
  InfoCard(this.scan);

  final ScanResult scan;
  static final dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: Icon(PlatformIcons(context).info),
        title: Text(scan.purl.toString(), style: TextStyle(fontSize: 20)),
        subtitle: Text('Scanned: ${dateFormat.format(scan.timestamp)}'),
      ),
    );
  }
}
