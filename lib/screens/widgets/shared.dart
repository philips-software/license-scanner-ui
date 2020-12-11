/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showError(BuildContext context, Object error) {
  log(error);
  Toast.show(error.toString(), context, duration: 10);
}
