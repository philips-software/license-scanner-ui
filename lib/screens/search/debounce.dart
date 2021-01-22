/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'dart:async';

/// Waits for a [period] before invoking an action.
class Debounce {
  final Duration period;

  Debounce(this.period);

  Timer _timer;

  run(Function() action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(period, action);
  }
}
