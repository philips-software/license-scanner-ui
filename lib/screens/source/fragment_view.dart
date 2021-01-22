/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
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
