import 'package:flutter/material.dart';
import 'package:license_scanner_ui/services/scan_result.dart';

class PackageWidget extends Card {
  final ScanResult package;

  PackageWidget(this.package, {void Function() onTap})
      : super(
          child: ListTile(
            leading: Icon(Icons.source),
            title: Text('${package.name} ${package.version}'),
            subtitle: Text(package.namespace),
            onTap: onTap,
          ),
        );
}
