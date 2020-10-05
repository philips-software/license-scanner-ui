/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';

import '../../services/scan_result.dart';

class PackageWidget extends StatelessWidget {
  final ScanResult package;
  final Function onTap;

  PackageWidget(this.package, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.source),
      title: Text('${package.name} ${package.version}'),
      subtitle: Text(package.namespace),
      onTap: onTap,
    );
  }
}
