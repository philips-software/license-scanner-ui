/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

import 'dart:async';

/// Waits for a [period] before invoking an action.
class Debounce {
  final Duration period;

  Timer _timer;

  Debounce(this.period);

  run(Function() action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(period, action);
  }
}
