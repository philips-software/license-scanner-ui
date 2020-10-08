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
