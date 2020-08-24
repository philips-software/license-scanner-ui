import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:license_scanner_ui/widgets/scan_widget.dart';
import 'package:provider/provider.dart';

import '../../services/scan_service.dart';

class ScansScreen extends StatelessWidget {
  ScanService _service;

  @override
  Widget build(BuildContext context) {
    _service ??= Provider.of<ScanService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recent scans'),
      ),
      body: StreamBuilder(
        stream: _service.lastScanned,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ScanResult> data = snapshot.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ScanWidget(data[index]));
          } else {
            return Text('Waiting...');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => Navigator.pushNamed(context, 'search'),
      ),
    );
  }
}
