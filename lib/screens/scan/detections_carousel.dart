/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../model/scan_result.dart';
import '../../services/scan_service.dart';
import 'detection_card.dart';

class DetectionsCarousel extends StatefulWidget {
  DetectionsCarousel(this.result, {this.onDetectionChange});

  final ScanResult result;
  final Function() onDetectionChange;

  @override
  _DetectionsCarouselState createState() => _DetectionsCarouselState();
}

class _DetectionsCarouselState extends State<DetectionsCarousel> {
  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.8);
    final service = Provider.of<ScanService>(context, listen: false);

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView(
            controller: controller,
            children: widget.result.detections
                .map((detection) => DetectionCard(
                      detection,
                      onIgnore: (_) => service
                          .ignore(widget.result, detection.license,
                              ignore: !detection.ignored)
                          .then((_) => setState(() {
                                detection.ignored = !detection.ignored;
                                widget.onDetectionChange();
                              })),
                    ))
                .toList(),
          ),
        ),
        if (widget.result.detections.length > 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmoothPageIndicator(
              controller: controller,
              count: widget.result.detections.length,
              onDotClicked: (index) => controller.jumpToPage(index),
            ),
          ),
      ],
    );
  }
}
