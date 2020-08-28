import 'package:flutter/material.dart';
import 'package:license_scanner_ui/screens/scan_screen.dart';
import 'package:provider/provider.dart';

import '../services/scan_result.dart';
import '../services/scan_service.dart';
import '../widgets/exception_widget.dart';
import '../widgets/scan_widget.dart';

class LatestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Latest scans'),
      ),
      body: StreamBuilder(
        stream: service.lastScanned,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ExceptionWidget(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return _scans(snapshot.data, service);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        tooltip: 'Search package',
        onPressed: () => Navigator.pushNamed(context, 'search'),
      ),
    );
  }

  RefreshIndicator _scans(List<ScanResult> data, ScanService service) {
    return RefreshIndicator(
      child: Scrollbar(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => ScanWidget(
            data[index],
            onTap: () {
              final scan = data[index];
              final uuid = scan.uuid;
              final args = ScanScreenParams(scan, service.getScanResult(uuid));
              return Navigator.of(context).pushNamed('scan', arguments: args);
            },
          ),
        ),
      ),
      onRefresh: () => service.refreshScans(),
    );
  }
}
