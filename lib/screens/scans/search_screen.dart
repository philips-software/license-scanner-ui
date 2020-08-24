import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/scan_result.dart';
import '../../services/scan_service.dart';
import '../../widgets/debounce.dart';
import '../../widgets/exception_widget.dart';
import '../../widgets/scan_widget.dart';

class SearchScreen extends StatelessWidget {
  final _debounce = Debounce(Duration(milliseconds: 200));
  ScanService _service;

  @override
  Widget build(BuildContext context) {
    _service ??= Provider.of<ScanService>(context, listen: false);

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
                    _debounce.run(() => _service.search(text));
                  }
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _service.lastSearched,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ExceptionWidget(snapshot.error);
                  }
                  if (snapshot.hasData) {
                    List<ScanResult> data = snapshot.data;
                    if (data.isEmpty) {
                      return Center(
                        child: Text('(No matches found)'),
                      );
                    }
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) =>
                            ScanWidget(data[index]));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ));
  }
}
