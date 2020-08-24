import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/scan_result.dart';
import '../../services/scan_service.dart';
import '../../widgets/exception_widget.dart';
import '../../widgets/scan_widget.dart';

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
          if (snapshot.hasError) {
            return ExceptionWidget(snapshot.error);
          }
          if (snapshot.hasData) {
            List<ScanResult> data = snapshot.data;
            return RefreshIndicator(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => ScanWidget(data[index]),
                ),
              ),
              onRefresh: () => _service.refreshScans(),
            );
          } else {
            return Text('Loading...');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        tooltip: 'Search package',
        onPressed: () => Navigator.pushNamed(context, 'search'),
      ),
    );
  }
}
