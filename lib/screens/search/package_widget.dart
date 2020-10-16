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

import '../../services/scan_result.dart';

class PackageWidget extends StatelessWidget {
  final ScanResult package;
  final Function onTap;

  PackageWidget(this.package, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Icon(Icons.source),
        title: Text('${package.name} ${package.version}'),
        subtitle: Text(package.namespace),
        onTap: onTap,
      ),
    );
  }
}
