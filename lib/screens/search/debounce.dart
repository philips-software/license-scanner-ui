/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
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
