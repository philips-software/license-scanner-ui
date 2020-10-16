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
import 'package:license_scanner_ui/services/scan_result.dart';

import 'scan_widget.dart';

class ScanList extends StatelessWidget {
  ScanList({this.results, this.onTap, this.onRefresh});

  final List<ScanResult> results;
  final Function(ScanResult scan) onTap;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scrollbar(
        child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) => ScanWidget(
            results[index],
            onTap: () => onTap(results[index]),
          ),
        ),
      ),
      onRefresh: onRefresh,
    );
  }
}


