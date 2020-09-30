import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:license_scanner_ui/widgets/exception_widget.dart';

import 'detections_card.dart';
import 'error_card.dart';
import 'license_card.dart';
import 'location_card.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScanScreenParams params = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
          title: Text('${params.package.name} - ${params.package.version}')),
      body: FutureBuilder(
        future: params.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ExceptionWidget(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          ScanResult scan = snapshot.data;
          return Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _namespaceView(scan),
                  if (scan.error != null) ErrorCard(scan),
                  if (scan.detections.isNotEmpty) DetectionsCard(scan),
                  LicenseCard(scan),
                  LocationCard(scan),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _namespaceView(ScanResult scan) =>
      (scan.namespace?.isNotEmpty ?? false)
          ? Text(
              scan.namespace,
              style: TextStyle(
                fontSize: 20,
              ),
            )
          : Text('(no namespace)');
}

class ScanScreenParams {
  final ScanResult package;
  final Future<ScanResult> future;

  ScanScreenParams(this.package, this.future);
}
