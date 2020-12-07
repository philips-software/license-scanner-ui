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
import 'package:license_scanner_ui/model/file_fragment.dart';

class FragmentView extends StatelessWidget {
  FragmentView(this.fragment);

  final FileFragment fragment;

  @override
  Widget build(BuildContext context) {
    var background = Theme.of(context).cardColor;

    return ListView.builder(
      itemCount: fragment.lines.length,
      itemBuilder: (context, index) {
        return Container(
          color: background,
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(' ${fragment.offset + index}'),
              ),
              Expanded(
                child: Text(
                  fragment.lines[index],
                  style: TextStyle(
                      backgroundColor: (index >= fragment.startLine &&
                              index < fragment.endLine)
                          ? Theme.of(context).brightness == Brightness.light
                              ? Colors.yellow
                              : Colors.blueGrey
                          : null),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
