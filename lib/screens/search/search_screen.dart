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
import 'package:provider/provider.dart';

import '../../services/scan_result.dart';
import '../../services/scan_service.dart';
import '../scan/scan_screen.dart';
import '../widgets/debounce.dart';
import '../widgets/exception_widget.dart';
import 'package_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _debounce = Debounce(Duration(milliseconds: 200));
  final _namespaceController = TextEditingController();
  final _nameController = TextEditingController();
  ScanService _service;

  @override
  void initState() {
    super.initState();
    _service = Provider.of<ScanService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        iosContentPadding: true,
        appBar: PlatformAppBar(
          title: Text('Search'),
        ),
        body: Column(
          children: [
            _textField(
              controller: _nameController,
              hint: 'Package name',
              ignoreEmpty: true,
            ),
            _textField(
              controller: _namespaceController,
              hint: 'Namespace',
            ),
            Expanded(
              child: StreamBuilder(
                stream: _service.lastSearched,
                initialData: <ScanResult>[],
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ExceptionWidget(snapshot.error);
                  }
                  if (!snapshot.hasData) {
                    return Center(child: PlatformCircularProgressIndicator());
                  }
                  return _packageList(snapshot.data, _service);
                },
              ),
            ),
          ],
        ));
  }

  Widget _textField({
    TextEditingController controller,
    String hint,
    bool ignoreEmpty = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: PlatformTextField(
        controller: controller,
        autofocus: true,
        material: (_, __) => MaterialTextFieldData(
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: IconButton(
              onPressed: () => controller.clear(),
              icon: Icon(PlatformIcons(context).clear),
            ),
          ),
        ),
        cupertino: (_, __) => CupertinoTextFieldData(
            placeholder: hint,
            suffix: PlatformIconButton(
              onPressed: () => controller.clear(),
              icon: Icon(PlatformIcons(context).clear),
            )),
        onChanged: (text) {
          if (!ignoreEmpty || text.isNotEmpty) _onTextChange(_service);
        },
      ),
    );
  }

  void _onTextChange(ScanService service) {
    final ns = _namespaceController.text;
    final name = _nameController.text;

    _debounce.run(() => service.search(ns, name));
  }

  Widget _packageList(List<ScanResult> data, ScanService service) {
    if (data.isEmpty) {
      return Center(
        child: Text('(No matches found)'),
      );
    }
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => PackageWidget(
              data[index],
              onTap: () {
                final package = data[index];
                final params = ScanScreenParams(
                    package, service.getPackageScanResult(package));
                Navigator.pushNamed(context, 'scan', arguments: params);
              },
            ));
  }
}
