import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:license_scanner_ui/services/scan_service.dart';
import 'package:license_scanner_ui/widgets/exception_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toast/toast.dart';

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
          return _screen(context, snapshot);
        },
      ),
    );
  }

  Widget _screen(BuildContext context, AsyncSnapshot snapshot) {
    ScanResult scan = snapshot.data;
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (scan.namespace.isNotEmpty) Text('(${scan.namespace})'),
            if (scan.location != null) _locationView(scan),
            _licenseView(context, scan),
          ],
        ),
      ),
    );
  }

  Widget _detectionsCarousel(List<Detection> detections) {
    final controller = PageController(viewportFraction: 0.8);

    return (detections.isEmpty)
        ? Text('(No detections)')
        : Column(
            children: [
              SizedBox(
                height: 150,
                child: PageView(
                  controller: controller,
                  children: detections.map((d) => _detectionView(d)).toList(),
                ),
              ),
              if (detections.length > 1) SizedBox(height: 16),
              if (detections.length > 1)
                SmoothPageIndicator(
                  controller: controller,
                  count: detections.length,
                  onDotClicked: (index) => controller.jumpToPage(index),
                ),
            ],
          );
  }

  Widget _detectionView(Detection detection) {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          Text(
            detection.license,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.text_snippet_outlined),
            title: Text('file: ${detection.file}'),
            dense: true,
          ),
          ListTile(
            leading: Icon(Icons.format_line_spacing),
            title: Text((detection.startLine != detection.endLine)
                ? 'line ${detection.startLine} - ${detection.endLine} (${1 + detection.endLine - detection.startLine} lines)'
                : 'line ${detection.startLine}'),
            dense: true,
          ),
          ListTile(
            leading: Icon(Icons.thumb_up_outlined),
            title: Text((detection.confirmations > 1)
                ? 'found in ${detection.confirmations} locations'
                : '(single detection)'),
            dense: true,
          )
        ],
      ),
    );
  }

  Widget _locationView(ScanResult result) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'scanned from: ${result.location}',
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () =>
                Clipboard.setData(new ClipboardData(text: result.location)),
          ),
        ],
      ),
    );
  }

  Widget _licenseView(BuildContext context, ScanResult result) {
    final controller = new TextEditingController();
    final ScanService service = Provider.of<ScanService>(context);
    controller.text = result.license;

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Licenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.check_circle, color: Colors.black),
          ),
          _detectionsCarousel(result.detections),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              autofocus: true,
            ),
          ),
          ButtonBar(
            children: [
              FlatButton.icon(
                icon: Icon(Icons.repeat),
                label: Text('RESCAN'),
                textColor: Colors.red,
                onPressed: () => service
                    .rescan(result, result.location)
                    .catchError((e) => _showError(context, e.toString())),
              ),
              FlatButton.icon(
                icon: Icon(Icons.verified),
                label: Text('CONFIRM'),
                textColor: Colors.green,
                onPressed: () => service
                    .confirm(result.uuid, controller.text)
                    .catchError((e) => _showError(context, e.toString())),
              ),
            ],
          )
        ],
      ),
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
