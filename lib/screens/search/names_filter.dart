/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';

import 'debounce.dart';
import 'search_field.dart';

class NamesFilter extends StatefulWidget {
  NamesFilter({this.onFilter});

  final Function(String namespace, String name) onFilter;

  @override
  _NamesFilterState createState() => _NamesFilterState();
}

class _NamesFilterState extends State<NamesFilter> {
  final _debounce = Debounce(Duration(milliseconds: 200));
  var _name = '';
  var _namespace = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SearchField(
            hint: 'Package name',
            ignoreEmpty: true,
            onChange: (name) => _onFilter(name: name),
          ),
          SearchField(
            hint: 'Namespace',
            ignoreEmpty: true,
            onChange: (namespace) => _onFilter(namespace: namespace),
          ),
        ]),
      ),
    );
  }

  void _onFilter({String namespace, String name}) {
    _namespace = namespace ?? _namespace;
    _name = name ?? _name;
    _debounce.run(() => widget.onFilter(_namespace, _name));
  }
}
