/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showError(BuildContext context, String message) {
  Toast.show(message, context);
}
