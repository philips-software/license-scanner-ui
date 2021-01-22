/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../model/scan_result.dart';
import '../../services/scan_service.dart';
import 'detection_view.dart';

class DetectionsCarousel extends StatefulWidget {
  DetectionsCarousel(this.result, {this.onDetectionChange});

  final ScanResult result;
  final Function() onDetectionChange;

  @override
  _DetectionsCarouselState createState() => _DetectionsCarouselState();
}

class _DetectionsCarouselState extends State<DetectionsCarousel> {
  final controller = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ScanService>(context, listen: false);

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView(
            controller: controller,
            children: widget.result.detections
                .map((detection) => DetectionView(
                      widget.result,
                      detection,
                      onIgnore: (_) => service
                          .ignore(widget.result, detection,
                              ignore: !detection.ignored)
                          .then(
                            (_) => setState(() {
                              widget.onDetectionChange();
                            }),
                          ),
                    ))
                .toList(growable: false),
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
