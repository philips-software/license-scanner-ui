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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
    return PlatformTextField(
      controller: _controller,
      autofocus: true,
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration(
          hintText: widget.hint,
          suffixIcon: IconButton(
            onPressed: () => _controller.clear(),
            icon: Icon(PlatformIcons(context).clear),
          ),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
          placeholder: widget.hint,
          suffix: PlatformIconButton(
            onPressed: () => _controller.clear(),
            icon: Icon(PlatformIcons(context).clear),
          )),
      onChanged: (input) {
        if (!widget.ignoreEmpty || input.isNotEmpty) {
          widget.onChange(input);
        }
      },
    );
  }
}
