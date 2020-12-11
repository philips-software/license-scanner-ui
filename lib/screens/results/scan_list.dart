/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../model/scan_result.dart';
import '../widgets/scan_result_tile.dart';

class ScanList extends StatelessWidget {
  ScanList(this.scans, {this.onTap, this.onRefresh});

  final List<ScanResult> scans;
  final Function(ScanResult scan) onTap;
  final Future Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scrollbar(
        child: ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index) => ScanResultTile(
            scans[index],
            onTap: () => onTap(scans[index]),
          ),
        ),
      ),
      onRefresh: onRefresh,
    );
  }
}
