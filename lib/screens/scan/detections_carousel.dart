import 'dart:async';

import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetectionsCarousel extends StatefulWidget {
  final List<Detection> detections;
  final StreamController _controller = StreamController<String>();

  Stream<String> get stream => _controller.stream;

  DetectionsCarousel(this.detections);

  @override
  _DetectionsCarouselState createState() => _DetectionsCarouselState();
}

class _DetectionsCarouselState extends State<DetectionsCarousel> {
  bool included = true;

  @override
  void dispose() {
    widget._controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.8);

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView(
            controller: controller,
            children: widget.detections.map((d) => _detectionCard(d)).toList(),
          ),
        ),
        if (widget.detections.length > 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmoothPageIndicator(
              controller: controller,
              count: widget.detections.length,
              onDotClicked: (index) => controller.jumpToPage(index),
            ),
          ),
      ],
    );
  }

  Widget _detectionCard(Detection detection) {
    return Card(
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
          ),
          // Center(
          //   child: Switch(
          //     value: included,
          //     onChanged: (value) => setState(() {
          //       included = value;
          //       widget._controller.add(detection.license);
          //     }),
          //   ),
          // ),
        ],
      ),
      elevation: 10,
      color: Colors.grey[50],
    );
  }
}
