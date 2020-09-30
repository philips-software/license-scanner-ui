/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';

class ExceptionWidget extends StatelessWidget {
  final Exception exception;

  ExceptionWidget(this.exception);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        exception.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
