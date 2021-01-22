/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
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
            CircularProgressIndicator.adaptive(),
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
