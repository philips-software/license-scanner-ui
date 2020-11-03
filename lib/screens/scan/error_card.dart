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

import '../../model/scan_result.dart';

class ErrorCard extends StatelessWidget {
  final ScanResult scan;

  ErrorCard(this.scan);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Card(
        color: Theme.of(context).errorColor,
        child: Column(children: [
          ListTile(
            leading: Icon(
              Icons.warning,
              color: Colors.yellow,
            ),
            title: Text(
              scan.error,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]),
      ),
    );
  }
}
