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

class SnapshotView<T> extends StatelessWidget {
  SnapshotView(this.snapshot, {this.builder, this.message});

  final AsyncSnapshot<T> snapshot;
  final Widget Function(T) builder;
  final String message;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return ErrorWidget(snapshot.error);
    }
    if (!snapshot.hasData) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      );
    }
    return builder(snapshot.data);
  }
}
