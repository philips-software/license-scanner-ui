import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:license_scanner_ui/widgets/exception_widget.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'detections_carousel.dart';

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
                  if (scan.error != null) _errorCard(context, scan),
                  _detectionsCard(context, scan),
                  _licenseCard(context, scan),
                  _locationCard(context, scan),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _namespaceView(ScanResult scan) => Text(
        '${scan.namespace ?? "-"}',
        style: TextStyle(
          fontSize: 20,
        ),
      );

  Widget _errorCard(BuildContext context, ScanResult scan) {
    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(
            Icons.warning,
            color: Colors.red,
          ),
          title: Text('Error'),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            scan.error,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ]),
    );
  }

  Widget _detectionsCard(BuildContext context, ScanResult result) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Detections'),
          ),
          DetectionsCarousel(result.detections),
        ],
      ),
    );
  }

  Widget _licenseCard(BuildContext context, ScanResult scan) {
    final ScanService service = Provider.of<ScanService>(context);
    final controller = new TextEditingController();
    controller.text = scan.license;

    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(Icons.verified),
          title: Text('License'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            autofocus: true,
          ),
        ),
        ButtonBar(children: [
          FlatButton.icon(
            icon: Icon(Icons.verified),
            label: Text('CONFIRM'),
            onPressed: () => service
                .confirm(scan.uuid, controller.text)
                .whenComplete(() => Navigator.of(context).pushReplacementNamed(
                    'scan',
                    arguments: ScanScreenParams(
                        scan, service.getScanResult(scan.uuid))))
                .catchError((e) => _showError(context, e.toString())),
          ),
        ])
      ]),
    );
  }

  Widget _locationCard(BuildContext context, ScanResult scan) {
    final ScanService service = Provider.of<ScanService>(context);
    final controller = new TextEditingController();
    controller.text = scan.location;

    return Card(
      child: Column(children: [
        ListTile(
          leading: Icon(Icons.location_pin),
          title: Text('Location'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TextField(
                  controller: controller,
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () =>
                    Clipboard.setData(new ClipboardData(text: controller.text)),
              ),
            ],
          ),
        ),
        ButtonBar(
          children: [
            FlatButton.icon(
              icon: Icon(Icons.repeat),
              label: Text('RESCAN'),
              onPressed: () => service
                  .rescan(scan, controller.text)
                  .whenComplete(() => Navigator.of(context).pop())
                  .catchError((e) => _showError(context, e.toString())),
            ),
          ],
        )
      ]),
    );
  }

  void _showError(BuildContext context, String message) {
    Toast.show(message, context);
  }
}

class ScanScreenParams {
  final ScanResult package;
  final Future<ScanResult> future;

  ScanScreenParams(this.package, this.future);
}
