/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';

import '../../services/scan_result.dart';

class ErrorCard extends StatelessWidget {
  final ScanResult scan;

  ErrorCard(this.scan);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
