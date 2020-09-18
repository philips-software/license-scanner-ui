import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetectionsCarousel extends StatelessWidget {
  final List<Detection> detections;

  DetectionsCarousel(this.detections);

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.8);

    return (detections.isEmpty)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text('(No licenses detected)'),
          )
        : Column(
            children: [
              SizedBox(
                height: 200,
                child: PageView(
                  controller: controller,
                  children: detections.map((d) => _detectionCard(d)).toList(),
                ),
              ),
              if (detections.length > 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: detections.length,
                    onDotClicked: (index) => controller.jumpToPage(index),
                  ),
                ),
            ],
          );
  }

  Widget _detectionCard(Detection detection) {
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
}
