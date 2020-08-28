import 'package:flutter/material.dart';
import 'package:license_scanner_ui/screens/scan_screen.dart';
import 'package:license_scanner_ui/widgets/package_widget.dart';
import 'package:provider/provider.dart';

import '../services/scan_result.dart';
import '../services/scan_service.dart';
import '../widgets/debounce.dart';
import '../widgets/exception_widget.dart';

class SearchScreen extends StatelessWidget {
  final _debounce = Debounce(Duration(milliseconds: 200));

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter (a part of) the package name',
                ),
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    _debounce.run(() => service.search(text));
                  }
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: service.lastSearched,
                initialData: <ScanResult>[],
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ExceptionWidget(snapshot.error);
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return _packageList(snapshot.data, service);
                },
              ),
            ),
          ],
        ));
  }

  Widget _packageList(List<ScanResult> data, ScanService service) {
    if (data.isEmpty) {
      return Center(
        child: Text('(No matches found)'),
      );
    }
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => PackageWidget(
              data[index],
              onTap: () {
                final package = data[index];
                final params = ScanScreenParams(
                    package, service.getPackageScanResult(package));
                Navigator.pushNamed(context, 'scan', arguments: params);
              },
            ));
  }
}
