/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  SearchField({this.hint, this.ignoreEmpty = false, this.onChange});

  final String hint;
  final bool ignoreEmpty;
  final Function(String input) onChange;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _controller.clear(),
        ),
      ),
      onChanged: (input) {
        if (!widget.ignoreEmpty || input.isNotEmpty) {
          widget.onChange(input);
        }
      },
    );
  }
}
