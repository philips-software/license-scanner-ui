/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SnapshotView<T> extends StatelessWidget {
  SnapshotView(this.snapshot, {this.child});

  final AsyncSnapshot<T> snapshot;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) return ErrorWidget(snapshot.error);
    if (!snapshot.hasData) return PlatformCircularProgressIndicator();
    return child;
  }
}


